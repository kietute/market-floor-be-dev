--
-- PostgreSQL database dump
--

-- Dumped from database version 14.11 (Homebrew)
-- Dumped by pg_dump version 14.11 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_role_enum AS ENUM (
    'user',
    'staff',
    'admin'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.address (
    id integer NOT NULL,
    street_address character varying NOT NULL,
    city character varying NOT NULL,
    state character varying NOT NULL,
    country character varying NOT NULL,
    zip_code character varying NOT NULL,
    user_id integer
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- Name: bid; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bid (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    description character varying NOT NULL,
    price_start integer NOT NULL,
    step_bid integer NOT NULL,
    price_win integer NOT NULL,
    reserve_price integer NOT NULL,
    category_id integer
);


--
-- Name: bid_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bid_id_seq OWNED BY public.bid.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying NOT NULL,
    properties jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    slug character varying,
    description character varying,
    image character varying
);


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: otp_code; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.otp_code (
    id integer NOT NULL,
    verify_url character varying NOT NULL,
    phone_number character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: otp_code_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.otp_code_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: otp_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.otp_code_id_seq OWNED BY public.otp_code.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id integer NOT NULL,
    upc character varying NOT NULL,
    name character varying NOT NULL,
    price jsonb NOT NULL,
    is_on_sale boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    category_id integer,
    full_description character varying NOT NULL,
    short_description character varying NOT NULL,
    nutrition_informations character varying NOT NULL
);


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: product_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_image (
    id integer NOT NULL,
    is_thumbnail boolean DEFAULT false NOT NULL,
    url character varying NOT NULL,
    product_id integer
);


--
-- Name: product_image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_image_id_seq OWNED BY public.product_image.id;


--
-- Name: store; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.store (
    id integer NOT NULL,
    name character varying NOT NULL,
    store_code integer,
    support_delivery boolean,
    support_pickup boolean,
    open_time integer,
    close_time integer
);


--
-- Name: store_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.store_id_seq OWNED BY public.store.id;


--
-- Name: store_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.store_product (
    id integer NOT NULL,
    inventory integer NOT NULL,
    product_id integer,
    store_id integer,
    price jsonb NOT NULL
);


--
-- Name: store_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.store_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: store_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.store_product_id_seq OWNED BY public.store_product.id;


--
-- Name: tenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant (
    id integer NOT NULL,
    name character varying NOT NULL,
    company_legal_name character varying NOT NULL,
    email character varying NOT NULL,
    company_phone_number character varying NOT NULL
);


--
-- Name: tenant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_id_seq OWNED BY public.tenant.id;


--
-- Name: tenant_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant_product (
    id integer NOT NULL,
    product_id integer,
    tenant_id integer
);


--
-- Name: tenant_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_product_id_seq OWNED BY public.tenant_product.id;


--
-- Name: user_device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_device (
    id integer NOT NULL,
    device_token character varying NOT NULL,
    user_id integer
);


--
-- Name: user_device_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_device_id_seq OWNED BY public.user_device.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    phone_number character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    role public.users_role_enum DEFAULT 'user'::public.users_role_enum NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    store_id integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: address id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- Name: bid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bid ALTER COLUMN id SET DEFAULT nextval('public.bid_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: otp_code id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.otp_code ALTER COLUMN id SET DEFAULT nextval('public.otp_code_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: product_image id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image ALTER COLUMN id SET DEFAULT nextval('public.product_image_id_seq'::regclass);


--
-- Name: store id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store ALTER COLUMN id SET DEFAULT nextval('public.store_id_seq'::regclass);


--
-- Name: store_product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_product ALTER COLUMN id SET DEFAULT nextval('public.store_product_id_seq'::regclass);


--
-- Name: tenant id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant ALTER COLUMN id SET DEFAULT nextval('public.tenant_id_seq'::regclass);


--
-- Name: tenant_product id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_product ALTER COLUMN id SET DEFAULT nextval('public.tenant_product_id_seq'::regclass);


--
-- Name: user_device id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device ALTER COLUMN id SET DEFAULT nextval('public.user_device_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.address (id, street_address, city, state, country, zip_code, user_id) FROM stdin;
\.


--
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bid (id, name, created_at, updated_at, description, price_start, step_bid, price_win, reserve_price, category_id) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (id, name, properties, created_at, updated_at, slug, description, image) FROM stdin;
1	Watches	[{"name": "Brand", "type": "string"}, {"name": "Model", "type": "string"}, {"name": "Price", "type": "number"}, {"name": "Water Resistance", "type": "boolean"}, {"name": "Material", "type": "string", "options": ["Leather", "Metal", "Rubber"]}]	2024-09-05 21:58:41.174813	2024-09-05 21:58:41.174813	\N	\N	\N
4	Smartphones	[{"name": "Brand", "type": "string"}, {"name": "Model", "type": "string"}, {"name": "Price", "type": "number"}, {"name": "Screen Size", "type": "number"}, {"name": "Operating System", "type": "string", "options": ["iOS", "Android", "Windows"]}]	2024-09-09 20:47:02.950231	2024-09-09 20:47:02.950231	\N	\N	\N
\.


--
-- Data for Name: otp_code; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.otp_code (id, verify_url, phone_number, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product (id, upc, name, price, is_on_sale, created_at, updated_at, category_id, full_description, short_description, nutrition_informations) FROM stdin;
1	123456789012	Sample Product	{"price": 19.99, "salePrice": 14.99, "displayPrice": "$19.99", "displaySalePrice": "$14.99"}	t	2024-09-04 13:15:49.14626	2024-09-04 13:15:49.14626	\N	This is a sample product used for demonstration purposes.	Sample product	Calories: 200, Fat: 10g, Carbs: 20g, Protein: 5g
2	123456789019	Sample Product 2	{"price": 20.99, "salePrice": 15.99, "displayPrice": "$20.99", "displaySalePrice": "$54.99"}	t	2024-09-05 13:14:20.017129	2024-09-05 13:14:20.017129	\N	This is a sample product used for demonstration purposes.	Sample product	Calories: 200, Fat: 10g, Carbs: 20g, Protein: 5g
\.


--
-- Data for Name: product_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_image (id, is_thumbnail, url, product_id) FROM stdin;
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.store (id, name, store_code, support_delivery, support_pickup, open_time, close_time) FROM stdin;
2	West Virgina Store	1	t	t	8	22
\.


--
-- Data for Name: store_product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.store_product (id, inventory, product_id, store_id, price) FROM stdin;
3	100	1	2	{"price": 19.99, "salePrice": 14.99, "displayPrice": "$19.99", "displaySalePrice": "$14.99"}
4	100	2	2	{"price": 20.99, "salePrice": 15.99, "displayPrice": "$20.99", "displaySalePrice": "$54.99"}
\.


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tenant (id, name, company_legal_name, email, company_phone_number) FROM stdin;
\.


--
-- Data for Name: tenant_product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tenant_product (id, product_id, tenant_id) FROM stdin;
\.


--
-- Data for Name: user_device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_device (id, device_token, user_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, phone_number, first_name, last_name, email, password, is_active, is_verified, role, created_at, updated_at, store_id) FROM stdin;
7	admin	+84819190221	Admin	Staterbros	admin_staterbros@gmail.com	c426f8f879fa877d.2ccd4d463174bc7e29b096f91904bcad91ae81bc53f0c6ebb48d62e142742dfe	t	t	admin	2024-09-04 12:59:53.833498	2024-09-04 12:59:53.833498	\N
9	staff	+84819190225	Staff	Staterbros	staff1@gmail.com	7703f4463642e2f6.78a1fd97b070f9fc68674939c869b45d667908ce82e8f1c7ed309e1671076a3c	t	f	staff	2024-09-04 13:44:46.186036	2024-09-04 13:44:46.186036	\N
10	kiethuynh1	+84819190227	Kiet	Huynh	kietmakietna@gmail.com	de33a7f1cebfe091.6f9e1f2882c940338e924b15e38aae16f51c8362564888d0c64fbdae08af21dd	t	t	user	2024-09-05 21:36:17.691914	2024-09-05 21:36:37.613055	\N
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.address_id_seq', 1, false);


--
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bid_id_seq', 1, false);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_id_seq', 5, true);


--
-- Name: otp_code_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.otp_code_id_seq', 5, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_id_seq', 2, true);


--
-- Name: product_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_image_id_seq', 1, false);


--
-- Name: store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.store_id_seq', 2, true);


--
-- Name: store_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.store_product_id_seq', 5, true);


--
-- Name: tenant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tenant_id_seq', 1, false);


--
-- Name: tenant_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tenant_product_id_seq', 1, false);


--
-- Name: user_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_device_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: user_device PK_0232591a0b48e1eb92f3ec5d0d1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT "PK_0232591a0b48e1eb92f3ec5d0d1" PRIMARY KEY (id);


--
-- Name: tenant_product PK_215cafeb4ff8a4d50a1f03953b0; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_product
    ADD CONSTRAINT "PK_215cafeb4ff8a4d50a1f03953b0" PRIMARY KEY (id);


--
-- Name: product_image PK_99d98a80f57857d51b5f63c8240; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image
    ADD CONSTRAINT "PK_99d98a80f57857d51b5f63c8240" PRIMARY KEY (id);


--
-- Name: category PK_9c4e4a89e3674fc9f382d733f03; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "PK_9c4e4a89e3674fc9f382d733f03" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: product PK_bebc9158e480b949565b4dc7a82; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "PK_bebc9158e480b949565b4dc7a82" PRIMARY KEY (id);


--
-- Name: otp_code PK_c2c773c7da0f03da4a23c4066a7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.otp_code
    ADD CONSTRAINT "PK_c2c773c7da0f03da4a23c4066a7" PRIMARY KEY (id);


--
-- Name: address PK_d92de1f82754668b5f5f5dd4fd5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT "PK_d92de1f82754668b5f5f5dd4fd5" PRIMARY KEY (id);


--
-- Name: tenant PK_da8c6efd67bb301e810e56ac139; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT "PK_da8c6efd67bb301e810e56ac139" PRIMARY KEY (id);


--
-- Name: store_product PK_de6af3a8762c59860794f42d8f2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_product
    ADD CONSTRAINT "PK_de6af3a8762c59860794f42d8f2" PRIMARY KEY (id);


--
-- Name: bid PK_ed405dda320051aca2dcb1a50bb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bid
    ADD CONSTRAINT "PK_ed405dda320051aca2dcb1a50bb" PRIMARY KEY (id);


--
-- Name: store PK_f3172007d4de5ae8e7692759d79; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT "PK_f3172007d4de5ae8e7692759d79" PRIMARY KEY (id);


--
-- Name: users UQ_17d1817f241f10a3dbafb169fd2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_17d1817f241f10a3dbafb169fd2" UNIQUE (phone_number);


--
-- Name: tenant UQ_3b26e49eb88be2de5246d69c5a2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT "UQ_3b26e49eb88be2de5246d69c5a2" UNIQUE (company_phone_number);


--
-- Name: tenant UQ_56211336b5ff35fd944f2259173; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT "UQ_56211336b5ff35fd944f2259173" UNIQUE (name);


--
-- Name: tenant UQ_5b5d9635409048b7144f5f23198; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT "UQ_5b5d9635409048b7144f5f23198" UNIQUE (email);


--
-- Name: product UQ_a0c8dae2b7ac9ecc90d15750a8d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "UQ_a0c8dae2b7ac9ecc90d15750a8d" UNIQUE (upc);


--
-- Name: tenant UQ_c1efb72faa98a44f0b5dcc99a63; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT "UQ_c1efb72faa98a44f0b5dcc99a63" UNIQUE (company_legal_name);


--
-- Name: tenant_product UQ_cb6db661acf414d75d8964aad62; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_product
    ADD CONSTRAINT "UQ_cb6db661acf414d75d8964aad62" UNIQUE (product_id, tenant_id);


--
-- Name: store UQ_eaf3d0b9edcf9fe6bc0cdf61f69; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT "UQ_eaf3d0b9edcf9fe6bc0cdf61f69" UNIQUE (store_code);


--
-- Name: store_product UQ_eb8d5fcb214fac7025e9ef0d6dc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_product
    ADD CONSTRAINT "UQ_eb8d5fcb214fac7025e9ef0d6dc" UNIQUE (product_id, store_id);


--
-- Name: product_name_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_name_tsvector_idx ON public.product USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: product FK_0dce9bc93c2d2c399982d04bef1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "FK_0dce9bc93c2d2c399982d04bef1" FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: address FK_35cd6c3fafec0bb5d072e24ea20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT "FK_35cd6c3fafec0bb5d072e24ea20" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_device FK_4875276d131a82b6792e73b9b1a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device
    ADD CONSTRAINT "FK_4875276d131a82b6792e73b9b1a" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tenant_product FK_8330aded28f7b05fe737345679b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_product
    ADD CONSTRAINT "FK_8330aded28f7b05fe737345679b" FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: bid FK_8ec9b8b3b8dcbb9993df8e6e7da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bid
    ADD CONSTRAINT "FK_8ec9b8b3b8dcbb9993df8e6e7da" FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: users FK_98a52595c9031d60f5c8d280ca4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_98a52595c9031d60f5c8d280ca4" FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: tenant_product FK_9df9440b0c9ff82e2f97d2f8cf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_product
    ADD CONSTRAINT "FK_9df9440b0c9ff82e2f97d2f8cf4" FOREIGN KEY (tenant_id) REFERENCES public.tenant(id);


--
-- Name: store_product FK_d4c18c1e1f18ea7dc540ba82f89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_product
    ADD CONSTRAINT "FK_d4c18c1e1f18ea7dc540ba82f89" FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: product_image FK_dbc7d9aa7ed42c9141b968a9ed3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image
    ADD CONSTRAINT "FK_dbc7d9aa7ed42c9141b968a9ed3" FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: store_product FK_f4f685a135a1e11dc5cf892fe54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_product
    ADD CONSTRAINT "FK_f4f685a135a1e11dc5cf892fe54" FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- PostgreSQL database dump complete
--

