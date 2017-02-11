-- -----------------------------------------------------
-- preferences
-- -----------------------------------------------------

INSERT INTO
    `preferences`
    (`key_name`, `value`, `default_value`, `summary`, `label`, `position`)
VALUES
    ('admin_uri_prefix', NULL, '/admin', 'pref.summary.admin_uri_prefix', NULL, NULL),
    ('addons_dir', NULL, 'addons', 'pref.summary.addons_dir', NULL, NULL)
;
