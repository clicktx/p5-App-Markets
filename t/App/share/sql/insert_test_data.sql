-- -----------------------------------------------------
-- Addons
-- -----------------------------------------------------

INSERT  INTO `markets`.`addons` (`id`, `name`, `is_enabled`)
VALUES  (1, 'Markets::Addon::TestAddon','1'),
        (2, 'Markets::Addon::DisableAddon', '0');

-- Addon hooks
-- -----------------------------------------------------

-- INSERT  INTO `markets`.`addons_hooks` (`id`, `addon_id`, `hook_name`, `priority`)
-- VALUES  (NULL, '1', 'before_compile_template', '300'),
--         (NULL, '1', 'before_xxx_action', '500');
