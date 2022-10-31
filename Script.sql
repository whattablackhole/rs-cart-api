--create table carts (
--	id uuid primary key default uuid_generate_v4(),
--	created_at date not null,
--	updated_at date not null
--)

--create table cart_items (
--cart_id uuid,
--product_id uuid,
--count integer,
--foreign key ("cart_id") references "carts" ("id"),
--primary key ("cart_id","product_id")
--)

--insert into carts (created_at, updated_at) values
--(NOW()::date, NOW()::date)
--
--insert into cart_items (cart_id, product_id, count) values
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 1),
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 2),
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 1),
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 3),
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 1),
--('d2d335fe-5fe9-4f6c-8edf-49e606a574e6', uuid_generate_v4(), 1)

--insert into cart_items (cart_id, product_id, count) values
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', '9d8ec09e-2ddf-453d-a93b-b950702986ec', 5),
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', '795e2bcc-cecf-4c07-b189-c133d84e43b1', 5),
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', 'b55050fd-2e10-457a-adbe-75e762de632f', 2),
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', 'f0280a79-762c-4d7e-bd4e-5b613ffd7944', 3),
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', '20480cd4-236a-41cc-bc28-ad5b7b3a3462', 1),
--('e91ff132-3cb2-4857-898f-d1b48a9a916d', '15b23955-2af5-44c7-ba46-addf2889d3a2', 2)

--  select id, product_id, count from carts
--  	  inner join cart_items
--  	  on carts.id = cart_items.cart_id
--      where cart_id = 'e91ff132-3cb2-4857-898f-d1b48a9a916e'

--INSERT into cart_items (cart_id, product_id, count) values
--    (
--      '75654266-4d98-42ca-9174-af5fbe756fa8', 'b55050fd-2e10-457a-adbe-75e762de632f', 7
--    )
--      ON CONFLICT (product_id) DO UPDATE
--        SET count = excluded.count

--DELETE FROM cart_items WHERE cart_items.cart_id = '75654266-4d98-42ca-9174-af5fbe756fa8';
 
--select id, product_id, count from carts
--  	  left join cart_items
--  	  on carts.id = cart_items.cart_id
--      where carts.id = '75654266-4d98-42ca-9174-af5fbe756fa8';
     
--CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
