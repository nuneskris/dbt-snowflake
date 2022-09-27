WITH raw_reviews AS ( SELECT
*
FROM
AIRBNB.RAW.RAW_REVIEWS
)
SELECT
listing_id,
date AS review_date, 
upper(CASE
    WHEN reviewer_name like '(%' THEN 'No Name'
    ELSE reviewer_name
END) AS reviewer_name,
comments AS review_text, 
sentiment AS review_sentiment
FROM
raw_reviews