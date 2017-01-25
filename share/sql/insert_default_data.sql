-- -----------------------------------------------------
-- Constants
-- -----------------------------------------------------

INSERT INTO `constants` (`name`, `default_value`, `value`, `summary`, `label`, `position`) VALUES
('ADMIN_PAGE_PREFIX', '/admin', NULL, NULL, NULL, NULL);

-- -----------------------------------------------------
-- preferences
-- -----------------------------------------------------

INSERT INTO
    `preferences`
    (`key`, `value`, `default_value`, `summary`, `label`, `position`)
VALUES
    ('admin_uri_prefix', NULL, '/admin', 'pref.summary.admin_uri_prefix', NULL, NULL),
    ('addons_dir', NULL, 'addons', 'pref.summary.addons_dir', NULL, NULL)
;
