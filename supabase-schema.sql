-- ═══════════════════════════════════════════════════════════════
--  سامانه خوداظهاری پرسنل — اسکریپت ساخت دیتابیس Supabase
--  این اسکریپت را در بخش  SQL Editor  پنل Supabase اجرا کنید.
-- ═══════════════════════════════════════════════════════════════

-- ---------- ۱) جدول رکوردهای پرسنل ----------
create table if not exists public.personnel_records (
  id             text primary key,          -- کد رهگیری (P...)
  created_at     timestamptz default now(), -- زمان ثبت (سیستمی)
  created_at_fa  text,                       -- تاریخ ثبت به شمسی/فارسی
  photo          text,                       -- عکس پرسنلی (base64)

  -- هویتی
  first_name     text,
  last_name      text,
  father_name    text,
  birth_date     text,
  birth_place    text,
  national_id    text unique,                -- کدملی (یکتا)
  gender         text,
  marital_status text,
  children_count text,
  nationality    text,
  blood_type     text,

  -- تحصیلی
  education_level text,
  education_field text,

  -- پرسنلی
  production_hall text,
  personnel_code  text,
  hire_date       text,
  position        text,

  -- سابقه کار
  work_history   jsonb default '[]'::jsonb,

  -- تماس
  mobile         text,
  phone          text,
  emergency_phone text,
  address        text,

  -- مهارت
  skills         text
);

-- ---------- ۲) جدول تنظیمات برنامه (key/value) ----------
-- نگهدارنده: سالن‌های تولید، پیکربندی بخش‌ها، تنظیمات صفحه خوشامد، رمز مدیر
create table if not exists public.app_config (
  key         text primary key,
  value       jsonb,
  updated_at  timestamptz default now()
);

-- ---------- ۳) فعال‌سازی Row Level Security ----------
alter table public.personnel_records enable row level security;
alter table public.app_config        enable row level security;

-- ---------- ۴) سیاست‌های دسترسی ----------
-- توجه امنیتی: چون برنامه کاملاً سمت مرورگر اجرا می‌شود و از کلید عمومی
-- (publishable/anon) استفاده می‌کند، این سیاست‌ها به همه اجازه خواندن/نوشتن
-- می‌دهند. برای محیط عملیاتی واقعی، بهتر است احراز هویت Supabase Auth یا
-- یک بک‌اند اضافه شود. (پایین‌تر توضیح داده شده)

drop policy if exists "public_all_records" on public.personnel_records;
create policy "public_all_records"
  on public.personnel_records
  for all
  using (true)
  with check (true);

drop policy if exists "public_all_config" on public.app_config;
create policy "public_all_config"
  on public.app_config
  for all
  using (true)
  with check (true);

-- ---------- ۵) مقادیر اولیه (اختیاری) ----------
insert into public.app_config (key, value) values
  ('admin_password', '"admin123"'::jsonb)
on conflict (key) do nothing;

-- پایان اسکریپت ✓
