--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 15.5

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: professors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professors (
    fname character varying(255) NOT NULL,
    lname character varying(255) NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.students (
    sno character varying(255) NOT NULL,
    name character varying(255),
    age integer
);


--
-- Name: take; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.take (
    sno character varying(255) NOT NULL,
    cno character varying(255) NOT NULL,
    grade integer
);


--
-- Name: teach; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teach (
    fname character varying(255) NOT NULL,
    lname character varying(255) NOT NULL,
    cno character varying(255) NOT NULL
);


--
-- Name: professors professors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professors
    ADD CONSTRAINT professors_pkey PRIMARY KEY (fname, lname);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (sno);


--
-- Name: take takes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.take
    ADD CONSTRAINT takes_pkey PRIMARY KEY (sno, cno);


--
-- Name: teach teach_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teach
    ADD CONSTRAINT teach_pkey PRIMARY KEY (fname, lname, cno);


--
-- Name: take takes_sno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.take
    ADD CONSTRAINT takes_sno_fkey FOREIGN KEY (sno) REFERENCES public.students(sno);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20240505141140);
INSERT INTO public."schema_migrations" (version) VALUES (20240510021416);
INSERT INTO public."schema_migrations" (version) VALUES (20240528022320);
INSERT INTO public."schema_migrations" (version) VALUES (20240528022852);
INSERT INTO public."schema_migrations" (version) VALUES (20240528023438);
