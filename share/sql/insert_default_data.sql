-- -----------------------------------------------------
-- Constants
-- -----------------------------------------------------

INSERT INTO `constants` (`name`, `default_value`, `value`, `summary`, `label`, `position`) VALUES
('ADMIN_PAGE_PREFIX', '/admin', NULL, NULL, NULL, NULL);

-- -----------------------------------------------------
-- Addons
-- -----------------------------------------------------

INSERT  INTO `markets`.`addons` (`id`, `name`, `is_enabled`)
VALUES  (1, 'Markets::Addon::DefaultFilter', 1)
        ,(102, 'Markets::Addon::MyAddon', 1)
        ,(103, 'Markets::Addon::DisableAddon', 0)
        ,(104, 'Markets::Addon::Newpage', 1)
;


-- Addon hooks
-- -----------------------------------------------------

INSERT INTO `addon_hooks` (`id`, `addon_id`, `hook_name`, `priority`)
VALUES  (100, 102, 'before_compile_template', 300),
        (101, 102, 'before_xxx_action', 500);
