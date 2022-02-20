/**
 * Multisite Network
 */
define('WP_ALLOW_MULTISITE', true);
define('MULTISITE', true);
define('SUBDOMAIN_INSTALL', true);
define('DOMAIN_CURRENT_SITE', env('DOMAIN_CURRENT_SITE') ?: parse_url(WP_HOME,  PHP_URL_HOST));
define('PATH_CURRENT_SITE', '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);

define('ADMIN_COOKIE_PATH', '/');
define('COOKIE_DOMAIN', '.'.DOMAIN_CURRENT_SITE);
define('COOKIEPATH', '');
define('SITECOOKIEPATH', '');