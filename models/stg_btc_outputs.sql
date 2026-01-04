{{ config(materialized='table')}}
select 
tx.HASH_KEY,
tx.BLOCK_NUMBER,
tx.BLOCK_TIMESTAMP,
tx.IS_COINBASE,
f.value:address::string as output_address,
f.value:value::float as output_value
from
{{ ref('stg_btc')}} tx,

LATERAL FLATTEN(INPUT => outputs) f

where f.value:address is not null