-- -----------------------------------------------------
-- Addons
-- -----------------------------------------------------

INSERT  INTO `markets`.`addons` (`id`, `name`, `is_enabled`)
VALUES  (1, 'default_filter', 1)
        ,(102, 'my_addon', 1)
        ,(103, 'disable_addon', 0)
        ,(104, 'newpage', 1)
;

-- Addon hooks
-- -----------------------------------------------------

INSERT INTO `addon_hooks` (`id`, `addon_id`, `hook_name`, `priority`)
VALUES  (100, 102, 'before_compile_template', 300),
        (101, 102, 'before_xxx_action', 500);
