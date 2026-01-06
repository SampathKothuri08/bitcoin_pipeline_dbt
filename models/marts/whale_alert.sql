
with whales as (
select 

output_address,
sum(output_value) as total_sent,
count(*) as txn_count 

from {{ ref('stg_btc_transactions')}}

where output_value > 10

group by output_address
order by total_sent desc
),
latest_price as (
    select 
    *
    from 
    {{ ref("btc_usd_max")}}
    where to_date(replace(snapped_at,'UTC','')) = current_date()
)

select 
w.output_address,
w.total_sent,
w.txn_count,
l.price,
(l.price * w.total_sent) as total_sent_usd
from whales w cross join latest_price l 
order by total_sent_usd desc