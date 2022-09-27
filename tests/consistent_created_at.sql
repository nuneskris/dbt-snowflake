SELECT *
FROM
    {{ ref('fct_reviews') }} fct_reviews,   {{ ref('dim_listings_cleansed') }} dim_listings_cleansed
WHERE 
fct_reviews.listing_id = dim_listings_cleansed.listing_id and
fct_reviews.review_date <= dim_listings_cleansed.created_at
LIMIT 10