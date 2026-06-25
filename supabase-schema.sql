-- =============================================
-- Tacos Sara's – Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- If tables already exist, run the ALTER TABLE below first.
-- =============================================

-- 1. Menu items
create table if not exists menu_items (
  id          text primary key,
  name        text not null,
  description text,
  price       numeric not null default 0,
  category    text not null default 'tacos',
  emoji       text,
  badge       text,
  image       text,
  available   boolean default true,
  sort_order  integer default 0,
  options     jsonb default '[]',
  created_at  timestamptz default now()
);

-- Add options column if table already existed without it
alter table menu_items add column if not exists options jsonb default '[]';

-- 2. Site configuration (restaurant info, slideshow, nosotros, etc.)
create table if not exists site_config (
  key        text primary key,
  value      jsonb,
  updated_at timestamptz default now()
);

-- ── Row Level Security ──────────────────────
alter table menu_items  enable row level security;
alter table site_config enable row level security;

-- Allow public (anon) to read everything
create policy if not exists "Public read – menu_items"  on menu_items  for select using (true);
create policy if not exists "Public read – site_config" on site_config for select using (true);

-- Allow anon to write (admin panel is password-protected at the UI level)
create policy if not exists "Admin write – menu_items"  on menu_items  for all using (true) with check (true);
create policy if not exists "Admin write – site_config" on site_config for all using (true) with check (true);

-- ── Seed default site config ────────────────
insert into site_config (key, value) values
('restaurant', '{
  "heroSub": "Birria artesanal cocinada a fuego lento con chiles guajillo y especias seleccionadas. El sabor que te hace volver.",
  "nosTitle": "Pasión por la birria,\namor por Sinaloa",
  "nosText": "En Tacos Sara''s nació un sueño sencillo: servir birria artesanal de calidad, preparada con las recetas de siempre y el cariño que solo se consigue en casa.",
  "address": "Callejón Zavala #21, Mochicahui\nCP 81890, Sinaloa, México",
  "phone": "668 103 0323",
  "whatsapp": "526681030323",
  "hours": "Lun–Dom: 8:00 am – 10:00 pm",
  "priceRange": "$100 – $200 por persona",
  "instagram": "https://www.instagram.com/tacossaras/",
  "facebook": "https://www.facebook.com/profile.php?id=61568119435030",
  "features": [
    {"icon":"fa-fire-flame-curved","title":"Birria artesanal","desc":"Chiles guajillo, ancho y especias cocinadas a fuego lento. La receta original de la casa."},
    {"icon":"fa-bowl-food","title":"Consomé incluido","desc":"Cada orden de birria viene con su consomé para taquear como debe ser."},
    {"icon":"fa-heart","title":"Para comer aquí o llevar","desc":"Ambiente familiar y servicio para llevar. También recibimos pedidos por WhatsApp."}
  ]
}'::jsonb),
('images', '{
  "about": "https://images.pexels.com/photos/5737244/pexels-photo-5737244.jpeg?auto=compress&cs=tinysrgb&w=800",
  "slides": [
    {"url":"https://images.pexels.com/photos/4110255/pexels-photo-4110255.jpeg?auto=compress&cs=tinysrgb&w=900","label":"Chiles y especias","tag":"El secreto de la birria"},
    {"url":"https://images.pexels.com/photos/5737244/pexels-photo-5737244.jpeg?auto=compress&cs=tinysrgb&w=900","label":"Birria en cocción","tag":"Horas de fuego lento"},
    {"url":"https://images.pexels.com/photos/2092507/pexels-photo-2092507.jpeg?auto=compress&cs=tinysrgb&w=900","label":"Tacos de birria","tag":"El resultado"},
    {"url":"https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=900","label":"Listos para servir 🔥","tag":"¡A tacar!"}
  ]
}'::jsonb),
('admin_password', '"saras2026"'::jsonb)
on conflict (key) do nothing;

-- ── Seed default menu items ─────────────────
insert into menu_items (id, name, description, price, category, emoji, badge, image, available, sort_order, options) values
('quesabirria','Quesabirria','Tortilla dorada con queso fundido y birria jugosa. Consomé para taquear incluido.',45,'tacos','🧀','Favorito','https://images.pexels.com/photos/3956439/pexels-photo-3956439.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,1,'[{"name":"Maíz","price":45},{"name":"Harina","price":50}]'),
('taco-birria','Taco de Birria','Carne de res cocinada a fuego lento en adobo de chiles guajillo y ancho, con cebolla, cilantro y consomé.',40,'tacos','🌮','⭐ Estrella','https://images.pexels.com/photos/2092507/pexels-photo-2092507.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,10,'[{"name":"Maíz","price":40},{"name":"Harina","price":45}]'),
('costra-queso','Costra de Queso','Tortilla con costra de queso dorado y birria jugosa por dentro. Crujiente y llena de sabor.',60,'tacos','🧀',null,'https://images.pexels.com/photos/4518670/pexels-photo-4518670.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,20,'[{"name":"Maíz","price":60},{"name":"Harina","price":70}]'),
('birria-caldo','Birria en Caldo','Birria de res en su caldo rojo con garbanzos, cebolla blanca, cilantro y limón. Pura alma sinaloense.',100,'birria','🍲',null,'https://images.pexels.com/photos/1731535/pexels-photo-1731535.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,30,'[{"name":"Orden","price":130},{"name":"½ Orden","price":100}]'),
('birria-dorada','Birria Dorada','Birria dorada a la perfección — crujiente por fuera, jugosa y llena de sabor por dentro.',120,'birria','🔥',null,'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,40,'[{"name":"Orden","price":150},{"name":"½ Orden","price":120}]'),
('sope','Sope','Masa de maíz gruesa con birria, frijoles, crema, queso y salsa. Una especialidad de la casa.',120,'especialidades','🫓',null,'https://images.pexels.com/photos/4518670/pexels-photo-4518670.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,50,null),
('sa-ramen','Sa-Ramen','El ramen al estilo Sara''s — fideos en consomé de birria con carne, cebolla y especias. Único y adictivo.',150,'especialidades','🍜','Especialidad','https://images.pexels.com/photos/1731535/pexels-photo-1731535.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,51,null),
('vampibirria','Vampibirria','Tostada de birria con queso fundido y todos los toppings. El vampiro de los antojitos de Mochicahui.',60,'especialidades','🧄',null,'https://images.pexels.com/photos/5737244/pexels-photo-5737244.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,52,null),
('burribirria','Burribirria','Burrito relleno de birria jugosa con queso, arroz y frijoles. Grande, contundente y delicioso.',100,'especialidades','🌯',null,'https://images.pexels.com/photos/2092507/pexels-photo-2092507.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,53,null),
('pellizcadas','Pellizcadas de Asientos','Masa de maíz pellizcada con asientos de cerdo. Un antojito clásico sinaloense.',25,'especialidades','🫓',null,'https://images.pexels.com/photos/4110255/pexels-photo-4110255.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,54,null),
('ref-vidrio','Refresco (vidrio)','Coca-Cola, Pepsi, Jarritos y otras marcas en botella de vidrio bien fría.',30,'bebidas','🥤',null,'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-50593.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,60,null),
('ref-600','Refresco 600 ml','Refresco en botella de 600 ml. Varias marcas disponibles.',35,'bebidas','🥤',null,'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-50593.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,61,null),
('agua-sabor','Aguas de Sabor','Jamaica, piña o té. Preparadas artesanalmente, frías y refrescantes para el calor de Sinaloa.',25,'bebidas','🌺',null,'https://images.pexels.com/photos/1337825/pexels-photo-1337825.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,62,null),
('agua-medio','Agua Natural ½ lt','Agua natural embotellada de medio litro. Fresca y pura.',20,'bebidas','💧',null,'https://images.pexels.com/photos/2109099/pexels-photo-2109099.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,63,null),
('agua-litro','Agua Natural 1 lt','Agua natural embotellada de un litro. Perfecta para compartir.',30,'bebidas','💧',null,'https://images.pexels.com/photos/2109099/pexels-photo-2109099.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,64,null),
('cafe-soluble','Café Soluble','Café soluble caliente, perfecto para comenzar la mañana.',30,'bebidas','☕',null,'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,65,null),
('cafe-colado','Café Colado','Café de olla colado, aromático y reconfortante. El clásico de las mañanas sinaloenses.',50,'bebidas','☕',null,'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,66,null),
('pastel-ciruela','Pastel de Ciruela','Pastel casero de ciruela, húmedo y esponjoso. El postre favorito de la casa.',75,'postres','🍰',null,'https://images.pexels.com/photos/8605562/pexels-photo-8605562.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,70,null),
('tres-leches','Pastel 3 Leches','El clásico pastel de tres leches, cremoso, suave y esponjoso. Hecho en casa con amor.',50,'postres','🎂','Casero','https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,71,null),
('quesadilla','Quesadilla','Quesadilla de maíz o harina con queso fundido. El complemento perfecto para tu orden.',20,'extras','🫓',null,'https://images.pexels.com/photos/5737244/pexels-photo-5737244.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,80,null),
('tortillas','Tortillas Recién Hechas','Tortillas de maíz hechas a mano, recién salidas del comal. La unidad.',5,'extras','🫓',null,'https://images.pexels.com/photos/4110255/pexels-photo-4110255.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,81,null),
('empaque','Empaque para Llevar','Empaque para llevar tu pedido cómodamente.',10,'extras','📦',null,'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,82,null)
on conflict (id) do nothing;
