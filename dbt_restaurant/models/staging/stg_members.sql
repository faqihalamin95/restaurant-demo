with source as (
    select * from {{ source('raw', 'members') }}
),

renamed as (
    select
        member_id,
        member_name,
        gender,
        cast(birth_year as integer) as birth_year,
        city,
        cast(join_date as date) as join_date,
        tier,
        cast(is_active as boolean) as is_active
    from source
)

select * from renamed
