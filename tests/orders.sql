with orderstest as ( select * from snowflake_sample_data_clone.tpch_sf1_clone.orders
)
select count(*) as ordercount
from orderstest
where o_shippriority < 0 