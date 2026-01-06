{ pkgs, lib, config, username, ... }:
let 

  system = "x86_64-linux";
  nixpkgs_22_05 = import (builtins.fetchGit {
      name = "old-nixpkgs-with-php74";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "380be19fbd2d9079f677978361792cb25e8a3635";
      }) { inherit system; };

  app = "koodasia_be";
  php_backends = [
    { name = "authentication"; port = 8080; entry = "/public";}
    { name = "account"; port = 8001; entry = "/public"; }
    { name = "serialnumber"; port = 8002; entry = "/public";}
    { name = "payment"; port = 8000; entry = "/public";}
    { name = "consumer"; port = 8003; entry = "/public";}
    { name = "notification"; port = 8004; entry = "/public";}
    { name = "distributor"; port = 8005; entry = "/public";}
    { name = "analytic"; port = 8006; entry = "/public";}
    { name = "qr_engine"; port = 8010; with_curl = true; entry = "/public";}
    { name = "kood_s3_service"; port = 8013; entry = ""; }
    { name = "integration"; port = 8011; entry = "/public";}
    { name = "dataprocess"; port = 8009; entry = "/public";}
    { name = "verifier"; port = 8012; entry = "/public";}
    { name = "message"; port = 8008; entry = "";}
    { name = "campaignV2"; port = 8017; repo_name = "campaign_v2"; entry = ""; }
  ];

  koodserver = {
    serverName = "_";
    listen = [ { addr = "127.0.0.1";  port = 80; } ];
    locations = builtins.listToAttrs (map (backend: { 
	  name = "/${backend.name}";
	  value = { 
	  proxyPass = "http://localhost:${toString backend.port}/${backend.name}";
	  recommendedProxySettings = true;
	  };
	  }) (php_backends ++ [
	    { name = "campaign"; port = 8007; }
	  ])
	);
  };

  smartkood_verifier = {
    serverName = "smartkood_verifier";
    listen = [ { addr = "*";  port = 7078; ssl = true; } ];
    forceSSL = true;
    sslCertificate = "/srv/http/koodasia_be.local/playground/cert/certificate.pem";
    sslCertificateKey = "/srv/http/koodasia_be.local/playground/cert/privatekey.pem";
    locations = {
      "/" = {
	recommendedProxySettings = true;
	proxyPass = "http://localhost:3000";
	proxyWebsockets = true; # needed if you need to use WebSocket
	  extraConfig =
	  ''
	  proxy_ssl_server_name on; 
	  proxy_pass_header Authorization;
	  ''
	  ;
      };
    };
  };
  
  playground_vhost = {

    name = "playground.local";
    value = {
      serverName = "playground.local";
      forceSSL = true;
      sslCertificate = "/srv/http/koodasia_be.local/playground/cert/certificate.pem";
      sslCertificateKey = "/srv/http/koodasia_be.local/playground/cert/privatekey.pem";
      listen = [ 
	{ addr = "playground.local"; port = 80; }
	{ addr = "playground.local"; port = 443; ssl = true; } 
	{ addr = "*"; port = 7077; ssl = true; }
      ];
      root = "${dataDir}/playground";
      locations = {
	"/" = {
	  recommendedProxySettings = true;
	  proxyPass = "http://localhost:5173";
	};
      };
    };
  };

  
  wordpress_vhost = {
    name = "wordpress.local";
    value = {
      serverName = "wordpress.local";
      listen = [ { addr = "wordpress.local"; port = 80; }];
      root = "${dataDir}/wordpress";
      locations = {
	"/" = {
	  tryFiles = "$uri $uri/ /index.php?$args =404";
	  index = "index.php index.html";
	};
	"/wp-json/" = {
	  extraConfig = ''
	    rewrite ^/wp-json/(.*)$ /index.php?rest_route=/$1 last;
	  '';
	};
	"/favicon.ico" = {
	  extraConfig = ''
	    log_not_found off;
	  access_log off;
	  '';
	};
	"~ \.php$" = {
	  index = "index.php";
	  extraConfig = ''
	    fastcgi_split_path_info ^(.+.php)(/.+)$;
	    include ${pkgs.nginx}/conf/fastcgi.conf;
	    include ${pkgs.nginx}/conf/fastcgi_params;
	    fastcgi_pass unix:${config.services.phpfpm.pools.wordpress.socket};
	    fastcgi_index index.php;
	  '';
	};
      };
    };
  };

  phpfpms_vhosts = (map (php_backend: {
      name = php_backend.name; 
      value = {
	serverName = "_";
	listen = [ { addr = "127.0.0.1";  port = php_backend.port; } ];
	root = "${dataDir}/${if (builtins.hasAttr "repo_name" php_backend) then php_backend.repo_name else php_backend.name}${php_backend.entry}";
	locations = {
	  "/" = {
	  tryFiles = "$uri $uri/ /index.php?$query_string";
	  index = "index.php";
	};
	  "~ \.php$" = {
	  extraConfig = ''
	  include ${pkgs.nginx}/conf/fastcgi.conf;
	  fastcgi_pass unix:${config.services.phpfpm.pools.${php_backend.name}.socket};
	  fastcgi_index index.php;
	  '';

	};
      };
    };
  }) php_backends) ++ [ wordpress_vhost playground_vhost];

  domain = "${app}.local";
  dataDir = "/srv/http/${domain}";
  phpfpm_setting = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 20;
      "pm.max_requests" = 50;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };

  phpfpm_setting_with_curl = phpfpm_setting // { "env[PATH]" = "${pkgs.curl}/bin"; };

  wordpress_phpfpm = {
      name = "wordpress";
      value = {
	user = app;
	settings = phpfpm_setting;
	phpPackage = pkgs.php84;
      };
  };

  playground_phpfpm = {
      name = "playground";
      value = {
	user = app;
	settings = phpfpm_setting;
	phpPackage = nixpkgs_22_05.php74;
      };
  };

  phpfpm_pools = (map (php_backend: {
      name = php_backend.name;
      value = {
	user = app;
	settings = if (php_backend.with_curl or false) then phpfpm_setting_with_curl else phpfpm_setting;
	phpPackage = nixpkgs_22_05.php74;
      };
  }) php_backends) ++ [ wordpress_phpfpm playground_phpfpm ];

in
{

  system.activationScripts.${app} = pkgs.lib.stringAfter [ "users" ]
    ''
      chmod g+rwx ${dataDir}
    '';

  networking.hosts = {
    # convenient if you're going to work on multiple sites
    "127.0.0.1" = [ "wordpress.local" "playground.local" ];
  };

  services.phpfpm.pools = builtins.listToAttrs phpfpm_pools;
  networking.firewall.allowedTCPPorts = [
    80
    7077
    7078
    4300
    8081
  ];

  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    home = dataDir;
    group  = app;
  };

  users.groups.${app} = { 
    name = "${app}"; 
    members = [ username config.services.nginx.user ];
  };

  services.redis.servers."smartkood".enable = true;
  services.redis.servers."smartkood".port = 6379;
  
  services.nginx = {
    clientMaxBodySize = "100M";
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    virtualHosts = (builtins.listToAttrs phpfpms_vhosts) // { koodserver = koodserver; smartkood_verifier = smartkood_verifier; };
  };
}
