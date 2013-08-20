CREATE 
    ALGORITHM = MERGE 
    DEFINER = `nbcpcmusr`@`66.77.88.35` 
    SQL SECURITY DEFINER
VIEW `NBCPCM02`.`vw_getScetGalleries` AS
    select 
        `gc`.`id` AS `category_id`,
        `gc`.`show_id` AS `site_id`,
        `gc`.`name` AS `category_name`,
        `gc`.`active` AS `category_active`,
        `gc`.`sort_order` AS `category_sort_order`,
        `gc`.`is_visible` AS `category_is_visible`,
        `gsc`.`id` AS `subcategory_id`,
        `gsc`.`name` AS `subcategory_name`,
        `gsc`.`sort_order` AS `subcategory_sort_order`,
        `gsc`.`is_visible` AS `subcategory_is_visible`,
        `gsc`.`active` AS `subcategory_active`,
        `g`.`id` AS `gallery_id`,
        `g`.`gallery_title` AS `gallery_title`,
        `g`.`description` AS `gallery_description`,
        `g`.`do_not_publish` AS `do_not_publish`,
        `g`.`active` AS `gallery_active`,
        `g`.`sunrise` AS `gallery_sunrise`,
        `g`.`sunset` AS `gallery_sunset`,
        if((((`g`.`sunrise` = _utf8'0000-00-00 00:00:00')
                or isnull(`g`.`sunrise`)
                or ((`g`.`sunrise` <> _utf8'0000-00-00 00:00:00')
                and (`g`.`sunrise` <= now())))
                and ((`g`.`sunset` = _utf8'0000-00-00 00:00:00')
                or isnull(`g`.`sunset`)
                or ((`g`.`sunset` <> _utf8'0000-00-00 00:00:00')
                and (`g`.`sunset` >= now())))),
            0,
            1) AS `gallery_is_expired`,
        `g`.`sort_order` AS `gallery_sort_order`,
        `g`.`is_visible` AS `gallery_is_visible`,
        `g`.`gallery_flags` AS `gallery_gallery_flags`,
        `g`.`poll_id` AS `gallery_poll_id`,
        `g`.`sort_field` AS `gallery_sort_field`,
        `g`.`sort_type` AS `gallery_sort_type`,
        `g`.`default_thumbnail` AS `gallery_default_thumbnail`,
        `gi`.`id` AS `gallery_item_id`,
        `gi`.`blurb1` AS `gallery_item_title`,
        `gi`.`blurb2` AS `gallery_item_description`,
        `gi`.`is_high_resolution` AS `gallery_item_is_high_resolution`,
        `gi`.`sequence` AS `gallery_item_sequence`,
        concat(`sfv`.`value`,
                `g`.`id`,
                _utf8'/#item=',
                `gi`.`id`) AS `gallery_item_url`,
        concat(_utf8'http://www.nbc.com/app2/img/95x88xC/scet/photos/',
                `gc`.`show_id`,
                _utf8'/',
                `g`.`id`,
                _utf8'/',
                `gi`.`filename`,
                _utf8'?cb=1') AS `gallery_item_thumb`,
        concat(_utf8'http://www.nbc.com/app2/img/500x495xS/scet/photos/',
                `gc`.`show_id`,
                _utf8'/',
                `g`.`id`,
                _utf8'/',
                `gi`.`filename`) AS `photo_uri`,
        concat(_utf8'http://www.nbc.com/app2/img/80x45xC/scet/photos/',
                `gc`.`show_id`,
                _utf8'/',
                `g`.`id`,
                _utf8'/',
                `gi`.`filename`) AS `mobile_thumb_uri`,
        concat(_utf8'http://www.nbc.com/app2/img/300x225xS/scet/photos/',
                `gc`.`show_id`,
                _utf8'/',
                `g`.`id`,
                _utf8'/',
                `gi`.`filename`) AS `mobile_iphone_uri`,
        concat(_utf8'http://www.nbc.com/app2/img/160x120xC/scet/photos/',
                `gc`.`show_id`,
                _utf8'/',
                `g`.`id`,
                _utf8'/',
                `gi`.`filename`) AS `mobile_fphone_uri`,
        `gi`.`average_rating` AS `average_rating`,
        `gi`.`total_ratings` AS `total_ratings`,
        `gi`.`view_count` AS `view_count`,
        `gi`.`published_date` AS `published_date`,
        `gi`.`filename` AS `filename`,
        1 AS `galleryItemsCount`
    from
        (((((`NBCPCM02`.`gallery_cats` `gc`
        join `NBCPCM02`.`gallery_subcats` `gsc` ON ((`gsc`.`gallery_cat_id` = `gc`.`id`)))
        join `NBCPCM02`.`galleries` `g` ON ((`g`.`gallery_subcat_id` = `gsc`.`id`)))
        left join `NBCPCM02`.`gallery_items` `gi` ON ((`gi`.`gallery_id` = `g`.`id`)))
        join `NBCPCM03`.`site_flag_value` `sfv` ON ((`sfv`.`site_id` = `gc`.`show_id`)))
        join `NBCPCM03`.`site_flag` `sf` ON (((`sf`.`site_flag_id` = `sfv`.`site_flag_id`)
            and (`sf`.`name` = _latin1'photos'))))
    where
        ((`gc`.`active` = 1)
            and (`gsc`.`active` = 1)
            and (`g`.`active` = 1)
            and (`g`.`do_not_publish` = 0))
