with source as (
    select * from {{ source('raw', 'branches') }}
),

renamed as (
    select
        branch_id,
        name                            as branch_name,
        location                        as branch_location,
        cast(opened_date as date)       as opened_date
    from source
)

select * from renamed
