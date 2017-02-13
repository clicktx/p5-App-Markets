-- -----------------------------------------------------
-- Addons
-- -----------------------------------------------------

INSERT  INTO `markets`.`addons` (`id`, `name`, `is_enabled`)
VALUES  (1, 'test_addon','1'),
        (2, 'disable_addon', '0');

-- Addon hooks
-- -----------------------------------------------------

-- INSERT  INTO `markets`.`addon_hooks` (`id`, `addon_id`, `hook_name`, `priority`)
-- VALUES  (NULL, '1', 'before_compile_template', '300'),
--         (NULL, '1', 'before_xxx_action', '500');
