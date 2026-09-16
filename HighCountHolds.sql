/* Retrieves a list of titles that have over 8 bib-level hold count
	no matter the amount of items
    3/29/2026 AGW
*/

WITH hold_counts AS (
    SELECT
        h.record_id AS bib_record_id,
        COUNT(h.id) AS hold_count
    FROM
        sierra_view.hold h
    GROUP BY
        h.record_id
),

item_totals AS (
    SELECT 
        brp.bib_record_id,
        COUNT(DISTINCT CASE 
            WHEN i.item_status_code NOT IN ('$', 'n', 'w', 'm')
            AND i.location_code NOT IN ('mfolb', 'mfold', 'bfol','bfolx' ) THEN i.id 
            ELSE NULL 
        END) AS item_totals
    FROM sierra_view.item_record i 
    JOIN sierra_view.bib_record_item_record_link bri ON i.id = bri.item_record_id
    JOIN sierra_view.bib_record_property brp ON bri.bib_record_id = brp.bib_record_id
    GROUP BY brp.bib_record_id
),

nonholdable_item_totals AS (
    SELECT 
        brp.bib_record_id,
        COUNT(DISTINCT CASE 
            WHEN i.item_status_code NOT IN ('$', 'n', 'w', 'm')
            AND i.location_code IN ('mfolb', 'mfold', 'bfol','bfolx' ) THEN i.id 
            ELSE NULL 
        END) AS non_hold_item_totals
    FROM sierra_view.item_record i 
    JOIN sierra_view.bib_record_item_record_link bri ON i.id = bri.item_record_id
    JOIN sierra_view.bib_record_property brp ON bri.bib_record_id = brp.bib_record_id
    GROUP BY brp.bib_record_id
),

outstanding_orders AS (
    SELECT 
        bro.bib_record_id,
        COUNT(DISTINCT o.id) AS order_count
    FROM sierra_view.order_record o 
    JOIN sierra_view.bib_record_order_record_link bro ON o.id = bro.order_record_id
    WHERE o.order_status_code = 'o'
    GROUP BY bro.bib_record_id
)

SELECT
    UPPER(peb.index_entry) AS "Call#",
    brp.best_author AS "Author",
    brp.best_title AS "Title",
    COALESCE(hc.hold_count, 0) AS "Holds",
    it.item_totals AS "Holdable Items",
    nit.non_hold_item_totals AS "Non-Holdable Items",
    COALESCE(oo.order_count, 0) AS "Outstanding Orders",
    'b' || rmb.record_num || 'a' AS "Bib Record Num"
    
FROM
    sierra_view.item_view i
JOIN sierra_view.record_metadata rmi ON rmi.id = i.id AND rmi.record_type_code = 'i'
JOIN sierra_view.bib_record_item_record_link bri ON bri.item_record_id = i.id
JOIN sierra_view.record_metadata rmb ON rmb.id = bri.bib_record_id AND rmb.record_type_code = 'b'
JOIN sierra_view.phrase_entry peb ON peb.record_id = bri.bib_record_id AND peb.index_tag = 'c'
JOIN sierra_view.bib_record_property brp ON brp.bib_record_id = bri.bib_record_id
LEFT JOIN hold_counts hc ON hc.bib_record_id = bri.bib_record_id
LEFT JOIN item_totals it ON it.bib_record_id = bri.bib_record_id
LEFT JOIN nonholdable_item_totals nit ON nit.bib_record_id = bri.bib_record_id
LEFT JOIN outstanding_orders oo ON oo.bib_record_id = bri.bib_record_id

WHERE
    hc.hold_count >= 8

GROUP BY 
    rmb.record_num, 
    brp.best_title, 
    brp.best_author, 
    peb.index_entry, 
    hc.hold_count, 
    it.item_totals, 
    nit.non_hold_item_totals,
    oo.order_count

ORDER BY
   "Call#",
    brp.best_author,
    brp.best_title;