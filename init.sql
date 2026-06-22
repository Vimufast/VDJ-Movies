-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE IF NOT EXISTS public.movies (
  id integer NOT NULL DEFAULT nextval('movies_id_seq'::regclass),
  title text NOT NULL,
  description text,
  thumbnail_url text,
  telegram_message_id integer,
  duration text,
  views integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  dj_name text NOT NULL DEFAULT 'Unknown'::text,
  telegram_link text,
  summary text,
  genre text,
  publisher_name text,
  size text,
  CONSTRAINT movies_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.reports (
  id integer NOT NULL DEFAULT nextval('reports_id_seq'::regclass),
  movie_id integer,
  reason text NOT NULL,
  status text DEFAULT 'pending'::text,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT reports_pkey PRIMARY KEY (id),
  CONSTRAINT reports_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id)
);
CREATE TABLE IF NOT EXISTS public.downloads (
  id integer NOT NULL DEFAULT nextval('downloads_id_seq'::regclass),
  movie_id integer,
  user_id text,
  status text DEFAULT 'completed'::text,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT downloads_pkey PRIMARY KEY (id),
  CONSTRAINT downloads_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id)
);
CREATE TABLE IF NOT EXISTS public.movie_views (
  id integer NOT NULL DEFAULT nextval('movie_views_id_seq'::regclass),
  movie_id integer,
  user_id text NOT NULL,
  viewed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT movie_views_pkey PRIMARY KEY (id),
  CONSTRAINT movie_views_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id)
);
CREATE TABLE IF NOT EXISTS public.users (
  id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
  username text NOT NULL UNIQUE,
  email text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  is_dj_manager boolean DEFAULT false,
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.djs (
  id integer NOT NULL DEFAULT nextval('djs_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  manager_user_id integer,
  status text DEFAULT 'open'::text,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT djs_pkey PRIMARY KEY (id),
  CONSTRAINT djs_manager_user_id_fkey FOREIGN KEY (manager_user_id) REFERENCES public.users(id)
);
CREATE TABLE IF NOT EXISTS public.series (
  id integer NOT NULL DEFAULT nextval('series_id_seq'::regclass),
  title text NOT NULL,
  description text,
  thumbnail_url text,
  user_id integer,
  dj_id integer,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT series_pkey PRIMARY KEY (id),
  CONSTRAINT series_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT series_dj_id_fkey FOREIGN KEY (dj_id) REFERENCES public.djs(id)
);
CREATE TABLE IF NOT EXISTS public.series_movies (
  series_id integer NOT NULL,
  movie_id integer NOT NULL,
  order_in_series integer NOT NULL,
  CONSTRAINT series_movies_pkey PRIMARY KEY (series_id, movie_id),
  CONSTRAINT series_movies_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id),
  CONSTRAINT series_movies_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id)
);
CREATE TABLE IF NOT EXISTS public.followers (
  follower_user_id integer NOT NULL,
  followed_dj_id integer NOT NULL,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT followers_pkey PRIMARY KEY (follower_user_id, followed_dj_id),
  CONSTRAINT followers_follower_user_id_fkey FOREIGN KEY (follower_user_id) REFERENCES public.users(id),
  CONSTRAINT followers_followed_dj_id_fkey FOREIGN KEY (followed_dj_id) REFERENCES public.djs(id)
);
CREATE TABLE IF NOT EXISTS public.notifications (
  id integer NOT NULL DEFAULT nextval('notifications_id_seq'::regclass),
  user_id integer,
  type text NOT NULL,
  message text NOT NULL,
  related_entity_id integer,
  related_entity_type text,
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE IF NOT EXISTS public.dj_approvals (
  id integer NOT NULL DEFAULT nextval('dj_approvals_id_seq'::regclass),
  dj_id integer,
  movie_id integer,
  uploader_user_id integer,
  status text DEFAULT 'pending'::text,
  reviewed_by_user_id integer,
  reviewed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT dj_approvals_pkey PRIMARY KEY (id),
  CONSTRAINT dj_approvals_dj_id_fkey FOREIGN KEY (dj_id) REFERENCES public.djs(id),
  CONSTRAINT dj_approvals_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id),
  CONSTRAINT dj_approvals_uploader_user_id_fkey FOREIGN KEY (uploader_user_id) REFERENCES public.users(id),
  CONSTRAINT dj_approvals_reviewed_by_user_id_fkey FOREIGN KEY (reviewed_by_user_id) REFERENCES public.users(id)
);
CREATE TABLE IF NOT EXISTS public.heartbeats (
  id integer NOT NULL DEFAULT nextval('heartbeats_id_seq'::regclass),
  ping_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT heartbeats_pkey PRIMARY KEY (id)
);