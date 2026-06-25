-- =============================================
-- Tacos Sara's – Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- =============================================

-- 1. Menu items
create table if not exists menu_items (
  id          text primary key,
  name        text not null,
  description text,
  price       numeric not null default 0,
  category    text not null default 'birria',
  emoji       text,
  badge       text,
  image       text,
  available   boolean default true,
  sort_order  integer default 0,
  created_at  timestamptz default now()
);

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
create policy "Public read – menu_items"  on menu_items  for select using (true);
create policy "Public read – site_config" on site_config for select using (true);

-- Allow anon to write (admin panel is password-protected at the UI level)
create policy "Admin write – menu_items"  on menu_items  for all using (true) with check (true);
create policy "Admin write – site_config" on site_config for all using (true) with check (true);

-- ── Seed default site config ────────────────
insert into site_config (key, value) values
('restaurant', '{
  "heroSub": "Birria artesanal cocinada a fuego lento con chiles guajillo y especias seleccionadas. El sabor que te hace volver.",
  "nosTitle": "Pasión por la birria,\namor por Sinaloa",
  "nosText": "En Tacos Sara'\''s nació un sueño sencillo: servir birria artesanal de calidad, preparada con las recetas de siempre y el cariño que solo se consigue en casa.",
  "address": "Tomás Rendón 21, Mochicahui\nCP 81890, Sinaloa, México",
  "phone": "668 210 0504",
  "whatsapp": "526682100504",
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
insert into menu_items (id, name, description, price, category, emoji, badge, image, available, sort_order) values
('birria-taco','Taco de Birria','Carne de res cocinada a fuego lento en adobo de chiles guajillo y ancho, servida en tortilla de maíz con cebolla, cilantro y consomé.',35,'birria','🥘','⭐ Estrella','https://images.pexels.com/photos/2092507/pexels-photo-2092507.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,1),
('quesabirria','Quesabirria','Tortilla dorada con queso oaxaca fundido y birria jugosa. El consomé para taquear no puede faltar.',45,'birria','🧀','Favorito','https://images.pexels.com/photos/3956439/pexels-photo-3956439.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,2),
('consome','Consomé de Birria','El caldo rojo donde se cuece la birria, con garbanzos, cebolla blanca, cilantro y limón. Pura alma.',50,'birria','🍲',null,'https://images.pexels.com/photos/1731535/pexels-photo-1731535.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,3),
('tostada','Tostada de Birria','Tostada crujiente con frijoles, birria deshebrada, crema, queso fresco y salsa roja.',38,'birria','🫓',null,'https://images.pexels.com/photos/4518670/pexels-photo-4518670.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,4),
('mulita','Mulita de Birria','Dos tortillas de maíz con queso fundido y birria dentro, doradas en el comal. Consomé para acompañar.',48,'birria','🌮',null,'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,5),
('pastor','Taco al Pastor','Carne marinada del trompo con piña, cebolla y cilantro sobre tortilla de maíz.',28,'tacos','🌮','Clásico','https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,10),
('asada','Taco de Carne Asada','Res a las brasas con guacamole, cebolla y chile toreado. Sabor intenso y jugoso.',35,'tacos','🥩',null,'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,11),
('pollo','Taco de Pollo','Pollo a la plancha, jugoso y sazonado, con salsas de la casa.',28,'tacos','🐔',null,'https://images.pexels.com/photos/2338407/pexels-photo-2338407.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,12),
('carnitas','Taco de Carnitas','Cerdo cocinado a la mexicana — suave, dorado y lleno de sabor.',30,'tacos','🐷',null,'https://images.pexels.com/photos/5737254/pexels-photo-5737254.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,13),
('jamaica','Agua de Jamaica','Flor de jamaica preparada artesanalmente. Fría, ligeramente dulce — ideal con la birria.',25,'bebidas','🌺',null,'https://images.pexels.com/photos/1337825/pexels-photo-1337825.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,20),
('horchata','Agua de Horchata','Horchata cremosa de arroz con canela. Fría y reconfortante para calmar el picante.',25,'bebidas','🍚',null,'https://images.pexels.com/photos/5840077/pexels-photo-5840077.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,21),
('limonada','Limonada Natural','Limonada fresca y natural, perfecta para el calor sinaloense.',22,'bebidas','🍋',null,'https://images.pexels.com/photos/2109099/pexels-photo-2109099.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,22),
('refresco','Refresco','Coca-Cola, Pepsi, Jarritos y otras bebidas frías.',20,'bebidas','🥤',null,'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-50593.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,23),
('flan','Flan Casero','Flan de vainilla preparado en casa, suave y cremoso con su caramelo dorado.',35,'postres','🍮','Casero','https://images.pexels.com/photos/8605562/pexels-photo-8605562.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,30),
('arroz-leche','Arroz con Leche','Arroz cremoso cocinado con leche, canela y azúcar. Servido frío.',30,'postres','🍚',null,'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,31),
('churros','Churros con Cajeta','Churros crujientes bañados en cajeta de leche de cabra.',40,'postres','🥐','Favorito','https://images.pexels.com/photos/3026804/pexels-photo-3026804.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,32),
('gelatina','Gelatina de Leche','Gelatina cremosa de leche con rompope. Refrescante y ligera.',25,'postres','🍧',null,'https://images.pexels.com/photos/5966437/pexels-photo-5966437.jpeg?auto=compress&cs=tinysrgb&w=600&h=450',true,33)
on conflict (id) do nothing;
