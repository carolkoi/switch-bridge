--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.1

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
-- Name: fn_fillstring(character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_fillstring(fill_prefix character varying, fill_length integer, fill_value character varying, fill_originalstr character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_fillstring character varying;
	v_originalstr character varying;
	v_actuallength integer;
BEGIN	
	--init default values
	v_fillstring:=NULL;
	v_originalstr:=NULL;
	v_actuallength:=0;

	--get the length to fill to
	if fill_prefix is NULL then
		begin
			v_actuallength:=fill_length;
		end;
	else
		begin
		select fill_length-length(fill_prefix) into v_actuallength;
		end;
	end if;
	
	--now start the fills
	select lpad(fill_originalstr, v_actuallength,fill_value) into v_originalstr;
	
	select 
	COALESCE(fill_prefix::character varying, '') || COALESCE(v_originalstr::character varying, '') into v_fillstring;
	
	RETURN v_fillstring;
EXCEPTION WHEN unique_violation THEN
	-- Do nothing
	RAISE NOTICE 'An error has occured in the process of generating the string';	
END;
$$;


ALTER FUNCTION public.fn_fillstring(fill_prefix character varying, fill_length integer, fill_value character varying, fill_originalstr character varying) OWNER TO postgres;

--
-- Name: fn_get_ref_number(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_get_ref_number(ref_name character varying, anchor_name character varying DEFAULT 'NONE'::character varying, ref_prefix character varying DEFAULT ''::character varying, ref_maxsize integer DEFAULT 18) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	v_ref_no_id integer;
	v_curvalue integer;
	v_date date;
	v_datetime timestamp;
	v_refstring character varying;
	v_prefix character varying;
BEGIN	
        --init the variables
	v_ref_no_id:=0;
	v_curvalue:=0;
	v_refstring:=NULL;
	--get the current date
	select now()::date into v_date;
	--now get the id
	EXECUTE 'SELECT ref_no_id,current_value
		FROM tbl_sys_ref_numbers
		WHERE reference_name=$1 and anchor_value=$2 and date_time_added::date = $3'
	INTO v_ref_no_id, v_curvalue
	USING ref_name, anchor_name, v_date;
	--get the current datetime
	select now()::timestamp into v_datetime;
	--now get the next id
	if FOUND and v_ref_no_id>0 then
		begin
			RAISE NOTICE 'An Item already exists, add 1';
			------
			v_curvalue:=v_curvalue+1;			
			---update the table
			UPDATE tbl_sys_ref_numbers
			SET current_value=v_curvalue, date_time_added=v_datetime
			WHERE ref_no_id=v_ref_no_id and anchor_value=anchor_name;
		end;
	else
		begin
			RAISE NOTICE 'New Item, start from 1';
			-----
			v_curvalue:=1;
			--insert an item
			INSERT INTO tbl_sys_ref_numbers(
			reference_name, current_value, anchor_value, date_time_added)
			VALUES (ref_name, v_curvalue, anchor_name, v_datetime);
		end;
	end if;
	--now format
	select substring(ref_prefix from 0 for 3) into v_prefix;
	RAISE NOTICE 'v_prefix is: %',v_prefix;
	--
	select COALESCE(v_prefix::character varying, '')  ||
	COALESCE(fn_fillstring(
			    NULL,
			    10,
			    '0',
			    v_curvalue::character varying
			)::character varying, '')  into v_prefix;
	RAISE NOTICE 'v_prefix is: %',v_prefix;
			
	--into the refstring
	select fn_fillstring(
			    to_char(current_timestamp, 'YYYYDDMM'),
			    ref_maxsize,
			    '0',
			    v_prefix
			) into v_refstring;
	
	RETURN v_refstring;
EXCEPTION WHEN unique_violation THEN
	-- Do nothing
	RAISE NOTICE 'An error has occured in the process of generating the string';	
END;
$_$;


ALTER FUNCTION public.fn_get_ref_number(ref_name character varying, anchor_name character varying, ref_prefix character varying, ref_maxsize integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media (
    id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL,
    collection_name character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL,
    mime_type character varying(255),
    disk character varying(255) NOT NULL,
    size bigint NOT NULL,
    manipulations json NOT NULL,
    custom_properties json NOT NULL,
    responsive_images json NOT NULL,
    order_column integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.media OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_id_seq OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: model_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_permissions OWNER TO postgres;

--
-- Name: model_has_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_roles OWNER TO postgres;

--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    description text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.role_has_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    description text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tbl_adt_user_access_log_user_access_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_adt_user_access_log_user_access_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_adt_user_access_log_user_access_log_id_seq OWNER TO postgres;

--
-- Name: tbl_adt_user_access_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_adt_user_access_log (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    user_access_log_id integer DEFAULT nextval('public.tbl_adt_user_access_log_user_access_log_id_seq'::regclass) NOT NULL,
    user_id character varying,
    consumer_key character varying,
    log_type character varying,
    source_type character varying,
    notes character varying,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_adt_user_access_log OWNER TO postgres;

--
-- Name: tbl_cmp_company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_cmp_company (
    companyid integer NOT NULL,
    companyname character varying(255) NOT NULL,
    companyaddress character varying(255) NOT NULL,
    companyemail character varying(255) NOT NULL,
    contactperson character varying(255) NOT NULL,
    companytype character varying(255) NOT NULL,
    addedby integer NOT NULL,
    ipaddress character varying(255) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tbl_cmp_company OWNER TO postgres;

--
-- Name: tbl_cmp_company_companyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_cmp_company_companyid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_cmp_company_companyid_seq OWNER TO postgres;

--
-- Name: tbl_cmp_company_companyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_cmp_company_companyid_seq OWNED BY public.tbl_cmp_company.companyid;


--
-- Name: tbl_cmp_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_cmp_product (
    productid integer NOT NULL,
    serviceproviderid integer NOT NULL,
    product character varying(255) NOT NULL,
    productcode character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    charges numeric(10,2) NOT NULL,
    commission numeric(10,2) NOT NULL,
    transactiontype character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    addedby integer NOT NULL,
    modifiedby integer NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.tbl_cmp_product OWNER TO postgres;

--
-- Name: tbl_cmp_product_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_cmp_product_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_cmp_product_productid_seq OWNER TO postgres;

--
-- Name: tbl_cmp_product_productid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_cmp_product_productid_seq OWNED BY public.tbl_cmp_product.productid;


--
-- Name: tbl_cus_aml_amlid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_cus_aml_amlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_cus_aml_amlid_seq OWNER TO postgres;

--
-- Name: tbl_cus_blacklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_cus_blacklist (
    date_time_added double precision,
    added_by integer,
    date_time_modified double precision,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    blacklist_id integer DEFAULT nextval('public.tbl_cus_aml_amlid_seq'::regclass) NOT NULL,
    partner_id character varying(20),
    customer_idnumber character varying(30),
    transaction_number character varying,
    customer_name character varying(500),
    mobile_number character varying(30),
    blacklist_status character varying(500),
    response text,
    blacklist_source character varying(30),
    remarks character varying(500),
    blacklisted boolean DEFAULT true,
    blacklist_version integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    csv_filename character varying(500),
    csv_header smallint DEFAULT 0,
    csv_data text
);


ALTER TABLE public.tbl_cus_blacklist OWNER TO postgres;

--
-- Name: tbl_password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.tbl_password_resets OWNER TO postgres;

--
-- Name: tbl_pvd_serviceprovider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_pvd_serviceprovider (
    serviceproviderid integer NOT NULL,
    companyid integer NOT NULL,
    moneyservicename character varying(255) NOT NULL,
    provideridentifier integer NOT NULL,
    accountnumber character varying(255) NOT NULL,
    serviceprovidercategoryid integer NOT NULL,
    cutofflimit numeric(10,2) NOT NULL,
    settlementaccount character varying(255) NOT NULL,
    b2cbalance numeric(10,2) NOT NULL,
    c2bbalance numeric(10,2) NOT NULL,
    processingmode character varying(255) NOT NULL,
    addedby integer NOT NULL,
    serviceprovidertype character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.tbl_pvd_serviceprovider OWNER TO postgres;

--
-- Name: tbl_pvd_serviceprovider_serviceproviderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_pvd_serviceprovider_serviceproviderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_pvd_serviceprovider_serviceproviderid_seq OWNER TO postgres;

--
-- Name: tbl_pvd_serviceprovider_serviceproviderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_pvd_serviceprovider_serviceproviderid_seq OWNED BY public.tbl_pvd_serviceprovider.serviceproviderid;


--
-- Name: tbl_sec_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sec_roles (
    roleid integer NOT NULL,
    rolename character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    roletype character varying(255) NOT NULL,
    rolestatus character varying(255) NOT NULL,
    addedby integer NOT NULL,
    ipaddress character varying(255) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.tbl_sec_roles OWNER TO postgres;

--
-- Name: tbl_sec_roles_roleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sec_roles_roleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sec_roles_roleid_seq OWNER TO postgres;

--
-- Name: tbl_sec_roles_roleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sec_roles_roleid_seq OWNED BY public.tbl_sec_roles.roleid;


--
-- Name: tbl_sys_banks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_banks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_banks_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_banks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_banks (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    bank_id integer DEFAULT nextval('public.tbl_sys_banks_id_seq'::regclass) NOT NULL,
    bank_name character varying,
    branch_name character varying,
    paybill character varying,
    bank_code character varying,
    branch_code character varying,
    swift_code character varying,
    pesalink_code character varying,
    service_provider character varying,
    switch_bank_code character varying,
    bank_status character varying DEFAULT 'ACTIVE'::character varying,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_sys_banks OWNER TO postgres;

--
-- Name: tbl_sys_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_currencies_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_currencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_currencies (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    currency_id integer DEFAULT nextval('public.tbl_sys_currencies_id_seq'::regclass) NOT NULL,
    currency_name character varying,
    currency_code character varying,
    currency_status character varying DEFAULT 'ACTIVE'::character varying,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_sys_currencies OWNER TO postgres;

--
-- Name: tbl_sys_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_documents_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_documents (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    document_id integer DEFAULT nextval('public.tbl_sys_documents_id_seq'::regclass) NOT NULL,
    document_type character varying,
    document_status character varying DEFAULT 'ACTIVE'::character varying
);


ALTER TABLE public.tbl_sys_documents OWNER TO postgres;

--
-- Name: tbl_sys_iso_iso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_iso_iso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_iso_iso_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_iso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_iso (
    date_time_added double precision,
    added_by integer,
    date_time_modified double precision,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    iso_id integer DEFAULT nextval('public.tbl_sys_iso_iso_id_seq'::regclass) NOT NULL,
    prev_iso_id integer,
    company_id integer,
    need_sync boolean DEFAULT false,
    synced boolean DEFAULT false,
    iso_source character varying,
    iso_type character varying,
    request_type character varying,
    iso_status character varying,
    iso_version integer DEFAULT 0,
    req_mti character varying,
    req_field1 character varying,
    req_field2 character varying,
    req_field3 character varying NOT NULL,
    req_field4 character varying,
    req_field5 character varying,
    req_field6 character varying,
    req_field7 character varying,
    req_field8 character varying,
    req_field9 character varying,
    req_field10 character varying,
    req_field11 character varying,
    req_field12 character varying,
    req_field13 character varying,
    req_field14 character varying,
    req_field15 character varying,
    req_field16 character varying,
    req_field17 character varying,
    req_field18 character varying,
    req_field19 character varying,
    req_field20 character varying,
    req_field21 character varying,
    req_field22 character varying,
    req_field23 character varying,
    req_field24 character varying,
    req_field25 character varying,
    req_field26 character varying,
    req_field27 character varying,
    req_field28 character varying,
    req_field29 character varying,
    req_field30 character varying,
    req_field31 character varying,
    req_field32 character varying,
    req_field33 character varying,
    req_field34 character varying,
    req_field35 character varying,
    req_field36 character varying,
    req_field37 character varying,
    req_field38 character varying,
    req_field39 character varying,
    req_field40 character varying,
    req_field41 character varying,
    req_field42 character varying,
    req_field43 character varying,
    req_field44 character varying,
    req_field45 character varying,
    req_field46 character varying,
    req_field47 character varying,
    req_field48 character varying,
    req_field49 character varying,
    req_field50 character varying,
    req_field51 character varying,
    req_field52 character varying,
    req_field53 character varying,
    req_field54 character varying,
    req_field55 character varying,
    req_field56 character varying,
    req_field57 character varying,
    req_field58 character varying,
    req_field59 character varying,
    req_field60 character varying,
    req_field61 character varying,
    req_field62 character varying,
    req_field63 character varying,
    req_field64 character varying,
    req_field65 character varying,
    req_field66 character varying,
    req_field67 character varying,
    req_field68 character varying,
    req_field69 character varying,
    req_field70 character varying,
    req_field71 character varying,
    req_field72 character varying,
    req_field73 character varying,
    req_field74 character varying,
    req_field75 character varying,
    req_field76 character varying,
    req_field77 character varying,
    req_field78 character varying,
    req_field79 character varying,
    req_field80 character varying,
    req_field81 character varying,
    req_field82 character varying,
    req_field83 character varying,
    req_field84 character varying,
    req_field85 character varying,
    req_field86 character varying,
    req_field87 character varying,
    req_field88 character varying,
    req_field89 character varying,
    req_field90 character varying,
    req_field91 character varying,
    req_field92 character varying,
    req_field93 character varying,
    req_field94 character varying,
    req_field95 character varying,
    req_field96 character varying,
    req_field97 character varying,
    req_field98 character varying,
    req_field99 character varying,
    req_field100 character varying,
    req_field101 character varying,
    req_field102 character varying,
    req_field103 character varying,
    req_field104 character varying,
    req_field105 character varying,
    req_field106 character varying,
    req_field107 character varying,
    req_field108 character varying,
    req_field109 character varying,
    req_field110 character varying,
    req_field111 character varying,
    req_field112 character varying,
    req_field113 character varying,
    req_field114 character varying,
    req_field115 character varying,
    req_field116 character varying,
    req_field117 character varying,
    req_field118 character varying,
    req_field119 character varying,
    req_field120 character varying,
    req_field121 character varying,
    req_field122 character varying,
    req_field123 character varying,
    req_field124 character varying,
    req_field125 character varying,
    req_field126 character varying,
    req_field127 character varying,
    req_field128 character varying,
    res_mti character varying,
    res_field1 character varying,
    res_field2 character varying,
    res_field3 character varying,
    res_field4 character varying,
    res_field5 character varying,
    res_field6 character varying,
    res_field7 character varying,
    res_field8 character varying,
    res_field9 character varying,
    res_field10 character varying,
    res_field11 character varying,
    res_field12 character varying,
    res_field13 character varying,
    res_field14 character varying,
    res_field15 character varying,
    res_field16 character varying,
    res_field17 character varying,
    res_field18 character varying,
    res_field19 character varying,
    res_field20 character varying,
    res_field21 character varying,
    res_field22 character varying,
    res_field23 character varying,
    res_field24 character varying,
    res_field25 character varying,
    res_field26 character varying,
    res_field27 character varying,
    res_field28 character varying,
    res_field29 character varying,
    res_field30 character varying,
    res_field31 character varying,
    res_field32 character varying,
    res_field33 character varying,
    res_field34 character varying,
    res_field35 character varying,
    res_field36 character varying,
    res_field37 character varying,
    res_field38 character varying,
    res_field39 character varying,
    res_field40 character varying,
    res_field41 character varying,
    res_field42 character varying,
    res_field43 character varying,
    res_field44 character varying,
    res_field45 character varying,
    res_field46 character varying,
    res_field47 character varying,
    res_field48 character varying,
    res_field49 character varying,
    res_field50 character varying,
    res_field51 character varying,
    res_field52 character varying,
    res_field53 character varying,
    res_field54 character varying,
    res_field55 character varying,
    res_field56 character varying,
    res_field57 character varying,
    res_field58 character varying,
    res_field59 character varying,
    res_field60 character varying,
    res_field61 character varying,
    res_field62 character varying,
    res_field63 character varying,
    res_field64 character varying,
    res_field65 character varying,
    res_field66 character varying,
    res_field67 character varying,
    res_field68 character varying,
    res_field69 character varying,
    res_field70 character varying,
    res_field71 character varying,
    res_field72 character varying,
    res_field73 character varying,
    res_field74 character varying,
    res_field75 character varying,
    res_field76 character varying,
    res_field77 character varying,
    res_field78 character varying,
    res_field79 character varying,
    res_field80 character varying,
    res_field81 character varying,
    res_field82 character varying,
    res_field83 character varying,
    res_field84 character varying,
    res_field85 character varying,
    res_field86 character varying,
    res_field87 character varying,
    res_field88 character varying,
    res_field89 character varying,
    res_field90 character varying,
    res_field91 character varying,
    res_field92 character varying,
    res_field93 character varying,
    res_field94 character varying,
    res_field95 character varying,
    res_field96 character varying,
    res_field97 character varying,
    res_field98 character varying,
    res_field99 character varying,
    res_field100 character varying,
    res_field101 character varying,
    res_field102 character varying,
    res_field103 character varying,
    res_field104 character varying,
    res_field105 character varying,
    res_field106 character varying,
    res_field107 character varying,
    res_field108 character varying,
    res_field109 character varying,
    res_field110 character varying,
    res_field111 character varying,
    res_field112 character varying,
    res_field113 character varying,
    res_field114 character varying,
    res_field115 character varying,
    res_field116 character varying,
    res_field117 character varying,
    res_field118 character varying,
    res_field119 character varying,
    res_field120 character varying,
    res_field121 character varying,
    res_field122 character varying,
    res_field123 character varying,
    res_field124 character varying,
    res_field125 character varying,
    res_field126 character varying,
    res_field127 character varying,
    res_field128 character varying,
    request character varying,
    response character varying,
    extra_data character varying,
    sync_message character varying,
    need_sending boolean DEFAULT true,
    sent boolean DEFAULT false,
    received boolean DEFAULT false,
    aml_check boolean DEFAULT true,
    aml_check_sent boolean DEFAULT false,
    aml_check_retries integer DEFAULT 0,
    aml_listed boolean DEFAULT false,
    posted boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    maker_checker_approve_status smallint DEFAULT 0,
    maker_checker_reject_status smallint DEFAULT 0,
    approved_at double precision,
    rejected_at double precision
);


ALTER TABLE public.tbl_sys_iso OWNER TO postgres;

--
-- Name: tbl_sys_iso_eod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_iso_eod (
    date_time_added double precision DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    date_time_modified double precision DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    eod_id integer DEFAULT 1 NOT NULL,
    retry_at double precision
);


ALTER TABLE public.tbl_sys_iso_eod OWNER TO postgres;

--
-- Name: tbl_sys_iso_eod_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_iso_eod_requests (
    date_time_added double precision DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    date_time_modified double precision DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    eod_request_id integer NOT NULL,
    field37 character varying,
    retries integer DEFAULT 0
);


ALTER TABLE public.tbl_sys_iso_eod_requests OWNER TO postgres;

--
-- Name: tbl_sys_iso_eod_requests_eod_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_iso_eod_requests_eod_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sys_iso_eod_requests_eod_request_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_iso_eod_requests_eod_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sys_iso_eod_requests_eod_request_id_seq OWNED BY public.tbl_sys_iso_eod_requests.eod_request_id;


--
-- Name: tbl_sys_iso_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_iso_types (
    date_time_added double precision,
    added_by integer,
    date_time_modified double precision,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    iso_type_id integer NOT NULL,
    company_id integer,
    iso_type character varying,
    description character varying,
    entries character varying
);


ALTER TABLE public.tbl_sys_iso_types OWNER TO postgres;

--
-- Name: tbl_sys_iso_types_iso_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_iso_types_iso_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sys_iso_types_iso_type_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_iso_types_iso_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sys_iso_types_iso_type_id_seq OWNED BY public.tbl_sys_iso_types.iso_type_id;


--
-- Name: tbl_sys_offline_iso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_offline_iso (
    date_time_added double precision,
    added_by integer,
    date_time_modified double precision,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    iso_offline_id integer NOT NULL,
    iso_id integer NOT NULL,
    prev_iso_id integer,
    company_id integer,
    need_sync boolean DEFAULT false,
    synced boolean DEFAULT false,
    iso_source character varying,
    iso_type character varying,
    request_type character varying,
    iso_status character varying,
    iso_version integer DEFAULT 0,
    req_mti character varying,
    req_field1 character varying,
    req_field2 character varying,
    req_field3 character varying,
    req_field4 character varying,
    req_field5 character varying,
    req_field6 character varying,
    req_field7 character varying,
    req_field8 character varying,
    req_field9 character varying,
    req_field10 character varying,
    req_field11 character varying,
    req_field12 character varying,
    req_field13 character varying,
    req_field14 character varying,
    req_field15 character varying,
    req_field16 character varying,
    req_field17 character varying,
    req_field18 character varying,
    req_field19 character varying,
    req_field20 character varying,
    req_field21 character varying,
    req_field22 character varying,
    req_field23 character varying,
    req_field24 character varying,
    req_field25 character varying,
    req_field26 character varying,
    req_field27 character varying,
    req_field28 character varying,
    req_field29 character varying,
    req_field30 character varying,
    req_field31 character varying,
    req_field32 character varying,
    req_field33 character varying,
    req_field34 character varying,
    req_field35 character varying,
    req_field36 character varying,
    req_field37 character varying,
    req_field38 character varying,
    req_field39 character varying,
    req_field40 character varying,
    req_field41 character varying,
    req_field42 character varying,
    req_field43 character varying,
    req_field44 character varying,
    req_field45 character varying,
    req_field46 character varying,
    req_field47 character varying,
    req_field48 character varying,
    req_field49 character varying,
    req_field50 character varying,
    req_field51 character varying,
    req_field52 character varying,
    req_field53 character varying,
    req_field54 character varying,
    req_field55 character varying,
    req_field56 character varying,
    req_field57 character varying,
    req_field58 character varying,
    req_field59 character varying,
    req_field60 character varying,
    req_field61 character varying,
    req_field62 character varying,
    req_field63 character varying,
    req_field64 character varying,
    req_field65 character varying,
    req_field66 character varying,
    req_field67 character varying,
    req_field68 character varying,
    req_field69 character varying,
    req_field70 character varying,
    req_field71 character varying,
    req_field72 character varying,
    req_field73 character varying,
    req_field74 character varying,
    req_field75 character varying,
    req_field76 character varying,
    req_field77 character varying,
    req_field78 character varying,
    req_field79 character varying,
    req_field80 character varying,
    req_field81 character varying,
    req_field82 character varying,
    req_field83 character varying,
    req_field84 character varying,
    req_field85 character varying,
    req_field86 character varying,
    req_field87 character varying,
    req_field88 character varying,
    req_field89 character varying,
    req_field90 character varying,
    req_field91 character varying,
    req_field92 character varying,
    req_field93 character varying,
    req_field94 character varying,
    req_field95 character varying,
    req_field96 character varying,
    req_field97 character varying,
    req_field98 character varying,
    req_field99 character varying,
    req_field100 character varying,
    req_field101 character varying,
    req_field102 character varying,
    req_field103 character varying,
    req_field104 character varying,
    req_field105 character varying,
    req_field106 character varying,
    req_field107 character varying,
    req_field108 character varying,
    req_field109 character varying,
    req_field110 character varying,
    req_field111 character varying,
    req_field112 character varying,
    req_field113 character varying,
    req_field114 character varying,
    req_field115 character varying,
    req_field116 character varying,
    req_field117 character varying,
    req_field118 character varying,
    req_field119 character varying,
    req_field120 character varying,
    req_field121 character varying,
    req_field122 character varying,
    req_field123 character varying,
    req_field124 character varying,
    req_field125 character varying,
    req_field126 character varying,
    req_field127 character varying,
    req_field128 character varying,
    res_mti character varying,
    res_field1 character varying,
    res_field2 character varying,
    res_field3 character varying,
    res_field4 character varying,
    res_field5 character varying,
    res_field6 character varying,
    res_field7 character varying,
    res_field8 character varying,
    res_field9 character varying,
    res_field10 character varying,
    res_field11 character varying,
    res_field12 character varying,
    res_field13 character varying,
    res_field14 character varying,
    res_field15 character varying,
    res_field16 character varying,
    res_field17 character varying,
    res_field18 character varying,
    res_field19 character varying,
    res_field20 character varying,
    res_field21 character varying,
    res_field22 character varying,
    res_field23 character varying,
    res_field24 character varying,
    res_field25 character varying,
    res_field26 character varying,
    res_field27 character varying,
    res_field28 character varying,
    res_field29 character varying,
    res_field30 character varying,
    res_field31 character varying,
    res_field32 character varying,
    res_field33 character varying,
    res_field34 character varying,
    res_field35 character varying,
    res_field36 character varying,
    res_field37 character varying,
    res_field38 character varying,
    res_field39 character varying,
    res_field40 character varying,
    res_field41 character varying,
    res_field42 character varying,
    res_field43 character varying,
    res_field44 character varying,
    res_field45 character varying,
    res_field46 character varying,
    res_field47 character varying,
    res_field48 character varying,
    res_field49 character varying,
    res_field50 character varying,
    res_field51 character varying,
    res_field52 character varying,
    res_field53 character varying,
    res_field54 character varying,
    res_field55 character varying,
    res_field56 character varying,
    res_field57 character varying,
    res_field58 character varying,
    res_field59 character varying,
    res_field60 character varying,
    res_field61 character varying,
    res_field62 character varying,
    res_field63 character varying,
    res_field64 character varying,
    res_field65 character varying,
    res_field66 character varying,
    res_field67 character varying,
    res_field68 character varying,
    res_field69 character varying,
    res_field70 character varying,
    res_field71 character varying,
    res_field72 character varying,
    res_field73 character varying,
    res_field74 character varying,
    res_field75 character varying,
    res_field76 character varying,
    res_field77 character varying,
    res_field78 character varying,
    res_field79 character varying,
    res_field80 character varying,
    res_field81 character varying,
    res_field82 character varying,
    res_field83 character varying,
    res_field84 character varying,
    res_field85 character varying,
    res_field86 character varying,
    res_field87 character varying,
    res_field88 character varying,
    res_field89 character varying,
    res_field90 character varying,
    res_field91 character varying,
    res_field92 character varying,
    res_field93 character varying,
    res_field94 character varying,
    res_field95 character varying,
    res_field96 character varying,
    res_field97 character varying,
    res_field98 character varying,
    res_field99 character varying,
    res_field100 character varying,
    res_field101 character varying,
    res_field102 character varying,
    res_field103 character varying,
    res_field104 character varying,
    res_field105 character varying,
    res_field106 character varying,
    res_field107 character varying,
    res_field108 character varying,
    res_field109 character varying,
    res_field110 character varying,
    res_field111 character varying,
    res_field112 character varying,
    res_field113 character varying,
    res_field114 character varying,
    res_field115 character varying,
    res_field116 character varying,
    res_field117 character varying,
    res_field118 character varying,
    res_field119 character varying,
    res_field120 character varying,
    res_field121 character varying,
    res_field122 character varying,
    res_field123 character varying,
    res_field124 character varying,
    res_field125 character varying,
    res_field126 character varying,
    res_field127 character varying,
    res_field128 character varying,
    request character varying,
    response character varying,
    extra_data character varying,
    sync_message character varying
);


ALTER TABLE public.tbl_sys_offline_iso OWNER TO postgres;

--
-- Name: tbl_sys_offline_iso_iso_offline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_offline_iso_iso_offline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sys_offline_iso_iso_offline_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_offline_iso_iso_offline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sys_offline_iso_iso_offline_id_seq OWNED BY public.tbl_sys_offline_iso.iso_offline_id;


--
-- Name: tbl_sys_partners_partners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_partners_partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_partners_partners_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_partners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_partners (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    partner_idx integer DEFAULT nextval('public.tbl_sys_partners_partners_id_seq'::regclass) NOT NULL,
    partner_id character varying NOT NULL,
    setting_profile character varying,
    partner_name character varying,
    partner_type character varying,
    partner_username character varying,
    partner_password character varying,
    partner_api_endpoint character varying,
    allowed_transaction_types character varying,
    unlock_time integer,
    lock_status character varying,
    partner_status character varying DEFAULT 'ACTIVE'::character varying,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_sys_partners OWNER TO postgres;

--
-- Name: tbl_sys_paybills_paybill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_paybills_paybill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_paybills_paybill_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_paybills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_paybills (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    paybill_id integer DEFAULT nextval('public.tbl_sys_paybills_paybill_id_seq'::regclass) NOT NULL,
    setting_profile character varying DEFAULT 'DEFAULT'::character varying,
    paybill_type character varying,
    api_application_name character varying,
    api_consumer_key character varying,
    api_consumer_secret character varying,
    api_consumer_code character varying,
    api_endpoint character varying,
    api_host character varying,
    shortcode character varying,
    partnercode character varying,
    paybill_status character varying DEFAULT 'ACTIVE'::character varying,
    record_version integer DEFAULT 0,
    accountnumber character varying
);


ALTER TABLE public.tbl_sys_paybills OWNER TO postgres;

--
-- Name: tbl_sys_references_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_references_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sys_references_reference_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_references; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_references (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    reference_id integer DEFAULT nextval('public.tbl_sys_references_reference_id_seq'::regclass) NOT NULL,
    prefix character varying,
    suffix character varying,
    anchor_1 character varying,
    anchor_2 character varying,
    anchor_3 character varying,
    reference integer DEFAULT 1,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_sys_references OWNER TO postgres;

--
-- Name: tbl_sys_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sys_settings_setting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_sys_settings_setting_id_seq OWNER TO postgres;

--
-- Name: tbl_sys_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sys_settings (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    source_ip character varying,
    latest_ip character varying,
    setting_id integer DEFAULT nextval('public.tbl_sys_settings_setting_id_seq'::regclass) NOT NULL,
    setting_profile character varying DEFAULT 'DEFAULT'::character varying,
    setting_name character varying,
    setting_value character varying,
    setting_type character varying,
    setting_status character varying,
    record_version integer DEFAULT 0,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tbl_sys_settings OWNER TO postgres;

--
-- Name: tbl_trn_aml_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_trn_aml_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_trn_aml_id_seq OWNER TO postgres;

--
-- Name: tbl_trn_incidents_incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_trn_incidents_incident_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_trn_incidents_incident_id_seq OWNER TO postgres;

--
-- Name: tbl_trn_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_trn_incidents (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    user_activity_log_id integer,
    source_ip character varying,
    latest_ip character varying,
    incident_id integer DEFAULT nextval('public.tbl_trn_incidents_incident_id_seq'::regclass) NOT NULL,
    request_id integer,
    request_number character varying,
    partner_id character varying,
    partner_name character varying,
    transaction_ref character varying,
    transaction_date character varying,
    collection_branch character varying,
    transaction_type character varying,
    service_type character varying,
    sender_type character varying,
    sender_full_name character varying,
    sender_address character varying,
    sender_city character varying,
    sender_country_code character varying,
    sender_currency_code character varying,
    sender_mobile character varying,
    send_amount numeric DEFAULT 0,
    sender_id_type character varying,
    sender_id_number character varying,
    receiver_type character varying,
    receiver_full_name character varying,
    receiver_country_code character varying,
    receiver_currency_code character varying,
    receiver_amount numeric DEFAULT 0,
    receiver_city character varying,
    receiver_address character varying,
    receiver_mobile character varying,
    mobile_operator character varying,
    receiver_id_type character varying,
    receiver_id_number character varying,
    receiver_account character varying,
    receiver_bank character varying,
    receiver_bank_code character varying,
    receiver_swiftcode character varying,
    receiver_branch character varying,
    receiver_branch_code character varying,
    exchange_rate numeric DEFAULT 1,
    commission_amount numeric DEFAULT 0,
    paybill character varying,
    remarks character varying,
    callbacks character varying,
    original_message text,
    incident_code character varying,
    incident_note character varying,
    incident_description character varying,
    record_version integer DEFAULT 0,
    sent boolean DEFAULT false
);


ALTER TABLE public.tbl_trn_incidents OWNER TO postgres;

--
-- Name: tbl_trn_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_trn_requests_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_trn_requests_request_id_seq OWNER TO postgres;

--
-- Name: tbl_trn_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_trn_requests (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    user_activity_log_id integer,
    source_ip character varying,
    latest_ip character varying,
    request_id integer DEFAULT nextval('public.tbl_trn_requests_request_id_seq'::regclass) NOT NULL,
    request_number character varying,
    request_hash character varying,
    request_status character varying DEFAULT 'NEW'::character varying,
    transactions integer DEFAULT 0,
    transactions_value numeric,
    original_message text,
    record_version integer DEFAULT 0
);


ALTER TABLE public.tbl_trn_requests OWNER TO postgres;

--
-- Name: tbl_trn_transaction_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_trn_transaction_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
    CYCLE;


ALTER TABLE public.tbl_trn_transaction_transaction_id_seq OWNER TO postgres;

--
-- Name: tbl_trn_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_trn_transactions (
    date_time_added integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    added_by integer,
    date_time_modified integer DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::integer,
    modified_by integer,
    user_activity_log_id integer,
    source_ip character varying,
    latest_ip character varying,
    transaction_id integer DEFAULT nextval('public.tbl_trn_transaction_transaction_id_seq'::regclass) NOT NULL,
    request_id integer,
    request_number character varying,
    partner_id character varying,
    partner_name character varying,
    transaction_ref character varying,
    transaction_date character varying,
    collection_branch character varying,
    transaction_type character varying,
    service_type character varying,
    sender_type character varying,
    sender_full_name character varying,
    sender_address character varying,
    sender_city character varying,
    sender_country_code character varying,
    sender_currency_code character varying,
    sender_mobile character varying,
    send_amount numeric DEFAULT 0,
    sender_id_type character varying,
    sender_id_number character varying,
    receiver_type character varying,
    receiver_full_name character varying,
    receiver_country_code character varying,
    receiver_currency_code character varying,
    receiver_amount numeric DEFAULT 0,
    receiver_city character varying,
    receiver_address character varying,
    receiver_mobile character varying,
    mobile_operator character varying,
    receiver_id_type character varying,
    receiver_id_number character varying,
    receiver_account character varying,
    receiver_bank character varying,
    receiver_bank_code character varying,
    receiver_swiftcode character varying,
    receiver_branch character varying,
    receiver_branch_code character varying,
    exchange_rate numeric DEFAULT 1,
    commission_amount numeric DEFAULT 0,
    remarks character varying,
    paybill character varying,
    transaction_number character varying,
    transaction_hash character varying,
    transaction_status character varying DEFAULT 'NEW'::character varying,
    original_message text,
    transaction_response character varying,
    switch_response character varying,
    query_status character varying,
    query_response character varying,
    callbacks character varying,
    callbacks_status character varying,
    queued_callbacks integer DEFAULT 0,
    completed_callbacks integer DEFAULT 0,
    callback_status integer DEFAULT 0,
    record_version integer DEFAULT 0,
    need_syncing boolean DEFAULT false,
    synced boolean DEFAULT false,
    sent boolean DEFAULT false,
    incident_code character varying,
    incident_description character varying,
    incident_note character varying
);


ALTER TABLE public.tbl_trn_transactions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    company_id integer NOT NULL,
    role_id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(60) NOT NULL,
    msisdn bigint NOT NULL,
    status character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    deleted_at time without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workflow_stage_approvers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_stage_approvers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    granted_by integer NOT NULL,
    workflow_stage_id integer NOT NULL,
    workflow_stage_type_id integer NOT NULL,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_stage_approvers OWNER TO postgres;

--
-- Name: workflow_stage_approvers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_stage_approvers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_stage_approvers_id_seq OWNER TO postgres;

--
-- Name: workflow_stage_approvers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_stage_approvers_id_seq OWNED BY public.workflow_stage_approvers.id;


--
-- Name: workflow_stage_checklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_stage_checklist (
    id integer NOT NULL,
    name character varying(100),
    text text,
    status smallint,
    workflow_stages_id integer NOT NULL,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_stage_checklist OWNER TO postgres;

--
-- Name: workflow_stage_checklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_stage_checklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_stage_checklist_id_seq OWNER TO postgres;

--
-- Name: workflow_stage_checklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_stage_checklist_id_seq OWNED BY public.workflow_stage_checklist.id;


--
-- Name: workflow_stage_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_stage_type (
    id integer NOT NULL,
    name character varying(100),
    slug character varying(100),
    weight integer,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_stage_type OWNER TO postgres;

--
-- Name: workflow_stage_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_stage_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_stage_type_id_seq OWNER TO postgres;

--
-- Name: workflow_stage_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_stage_type_id_seq OWNED BY public.workflow_stage_type.id;


--
-- Name: workflow_stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_stages (
    id integer NOT NULL,
    workflow_stage_type_id integer NOT NULL,
    workflow_type_id integer NOT NULL,
    weight integer,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_stages OWNER TO postgres;

--
-- Name: workflow_stages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_stages_id_seq OWNER TO postgres;

--
-- Name: workflow_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_stages_id_seq OWNED BY public.workflow_stages.id;


--
-- Name: workflow_step_checklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_step_checklist (
    id integer NOT NULL,
    name character varying(100),
    user_id integer,
    text text,
    status smallint,
    workflow_steps_id integer NOT NULL,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_step_checklist OWNER TO postgres;

--
-- Name: workflow_step_checklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_step_checklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_step_checklist_id_seq OWNER TO postgres;

--
-- Name: workflow_step_checklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_step_checklist_id_seq OWNED BY public.workflow_step_checklist.id;


--
-- Name: workflow_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_steps (
    id integer NOT NULL,
    workflow_stage_id integer NOT NULL,
    workflow_id integer NOT NULL,
    user_id integer NOT NULL,
    approved_at timestamp(0) without time zone,
    rejected_at timestamp(0) without time zone,
    weight integer,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_steps OWNER TO postgres;

--
-- Name: workflow_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_steps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_steps_id_seq OWNER TO postgres;

--
-- Name: workflow_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_steps_id_seq OWNED BY public.workflow_steps.id;


--
-- Name: workflow_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_types (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    type smallint DEFAULT '0'::smallint,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflow_types OWNER TO postgres;

--
-- Name: workflow_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflow_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflow_types_id_seq OWNER TO postgres;

--
-- Name: workflow_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflow_types_id_seq OWNED BY public.workflow_types.id;


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflows (
    id integer NOT NULL,
    user_id integer NOT NULL,
    workflow_type character varying(255) NOT NULL,
    model_id integer,
    model_type character varying(45),
    collection_name character varying(45),
    payload text,
    sent_by integer,
    approved smallint DEFAULT '0'::smallint,
    approved_at timestamp(0) without time zone,
    rejected_at timestamp(0) without time zone,
    awaiting_stage_id integer NOT NULL,
    deleted_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.workflows OWNER TO postgres;

--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workflows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflows_id_seq OWNER TO postgres;

--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: tbl_cmp_company companyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_cmp_company ALTER COLUMN companyid SET DEFAULT nextval('public.tbl_cmp_company_companyid_seq'::regclass);


--
-- Name: tbl_cmp_product productid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_cmp_product ALTER COLUMN productid SET DEFAULT nextval('public.tbl_cmp_product_productid_seq'::regclass);


--
-- Name: tbl_pvd_serviceprovider serviceproviderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_pvd_serviceprovider ALTER COLUMN serviceproviderid SET DEFAULT nextval('public.tbl_pvd_serviceprovider_serviceproviderid_seq'::regclass);


--
-- Name: tbl_sec_roles roleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sec_roles ALTER COLUMN roleid SET DEFAULT nextval('public.tbl_sec_roles_roleid_seq'::regclass);


--
-- Name: tbl_sys_iso_eod_requests eod_request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_eod_requests ALTER COLUMN eod_request_id SET DEFAULT nextval('public.tbl_sys_iso_eod_requests_eod_request_id_seq'::regclass);


--
-- Name: tbl_sys_iso_types iso_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_types ALTER COLUMN iso_type_id SET DEFAULT nextval('public.tbl_sys_iso_types_iso_type_id_seq'::regclass);


--
-- Name: tbl_sys_offline_iso iso_offline_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_offline_iso ALTER COLUMN iso_offline_id SET DEFAULT nextval('public.tbl_sys_offline_iso_iso_offline_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workflow_stage_approvers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers ALTER COLUMN id SET DEFAULT nextval('public.workflow_stage_approvers_id_seq'::regclass);


--
-- Name: workflow_stage_checklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_checklist ALTER COLUMN id SET DEFAULT nextval('public.workflow_stage_checklist_id_seq'::regclass);


--
-- Name: workflow_stage_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_type ALTER COLUMN id SET DEFAULT nextval('public.workflow_stage_type_id_seq'::regclass);


--
-- Name: workflow_stages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stages ALTER COLUMN id SET DEFAULT nextval('public.workflow_stages_id_seq'::regclass);


--
-- Name: workflow_step_checklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_step_checklist ALTER COLUMN id SET DEFAULT nextval('public.workflow_step_checklist_id_seq'::regclass);


--
-- Name: workflow_steps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_steps ALTER COLUMN id SET DEFAULT nextval('public.workflow_steps_id_seq'::regclass);


--
-- Name: workflow_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_types ALTER COLUMN id SET DEFAULT nextval('public.workflow_types_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media (id, model_type, model_id, collection_name, name, file_name, mime_type, disk, size, manipulations, custom_properties, responsive_images, order_column, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (migration, batch) FROM stdin;
2014_10_12_000000_create_users_table	1
2014_10_12_100000_create_password_resets_table	1
2019_12_17_062202_CreateCompaniesTable	1
2019_12_17_062227_CreateProductsTable	1
2019_12_17_062241_CreateServiceProvidersTable	1
2019_12_17_062318_CreateRolesTable	1
2019_12_17_064647_CreateAuditLogTable	1
2019_12_17_074413_CreateISOTable	2
2019_12_17_072051_CreateSwitchSettingsTable	3
2019_12_30_081942_CreateRefNoTable	4
2019_11_22_000004_create_password_resets_table	5
2019_11_28_070658_create_media_table	5
2019_12_01_000001_create_workflow_types_table	5
2019_12_01_000002_create_workflow_stage_type_table	5
2019_12_01_000006_create_workflow_stages_table	5
2019_12_01_000007_create_workflow_stage_approvers_table	5
2019_12_01_000008_create_workflow_stage_checklist_table	5
2019_12_01_000009_create_workflows_table	5
2019_12_01_000010_create_workflow_steps_table	5
2019_12_01_000011_create_workflow_step_checklist_table	5
2020_04_19_100555_create_permission_tables	5
\.


--
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
\.


--
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
1	App\\Models\\User	2
3	App\\Models\\User	5
2	App\\Models\\User	4
3	App\\Models\\User	6
\.


--
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_resets (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, guard_name, description, created_at, updated_at, deleted_at) FROM stdin;
1	Can View All Transactions	web	<p>This permission allows the user to view all the transactions and cannot perform any operations whatsoever related to a transaction.</p>	2020-05-12 08:38:59	2020-05-12 08:38:59	\N
2	Can Update Transaction	web	<p>This permission allow the user to edit / change transaction status.</p>	2020-05-12 08:40:05	2020-05-12 08:40:05	\N
3	Can Authorize Transaction Update	web	<p>This permission gives an user the right to authorize transaction update.</p>	2020-05-12 08:40:56	2020-05-12 08:40:56	\N
4	Can Create User	web	<p>Allows creation of new users into the system</p>	2020-05-12 08:41:31	2020-05-12 08:41:31	\N
5	Can Delete User	web	<p>Allows the user to delete users</p>	2020-05-12 08:42:06	2020-05-12 08:42:06	\N
7	Can Add Partners	web	\N	2020-05-12 09:16:26	2020-05-12 09:16:26	\N
8	Can Add Service Provider	web	\N	2020-05-12 09:16:47	2020-05-12 09:16:47	\N
9	Can View Service Providers	web	\N	2020-05-12 09:17:16	2020-05-12 09:17:16	\N
10	Can View Switch Settings	web	\N	2020-05-12 09:18:27	2020-05-12 09:18:27	\N
6	Can View Partners	web	<p>sds</p>	2020-05-12 09:16:08	2020-05-12 09:38:43	\N
11	Can View Blacklist Records	web	\N	2020-05-12 09:48:23	2020-05-12 09:48:23	\N
12	Can Add / Import Blacklist Records	web	\N	2020-05-12 09:48:48	2020-05-12 09:48:48	\N
\.


--
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
1	1
2	1
3	1
4	1
5	1
1	2
2	2
3	2
1	3
7	1
8	1
9	1
10	1
6	1
6	2
10	2
9	2
11	1
12	1
11	2
12	2
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, guard_name, description, created_at, updated_at, deleted_at) FROM stdin;
1	Super Administrator	web	<p>This is the super role in the system. User with this role has all rights / permissions to perform and oversee every operation in the system.</p>	2020-05-12 08:43:22	2020-05-12 08:43:22	\N
2	Administrator	web	<p>This user has a number of high administrative rights and permissions. He / She monitors and oversees all system operations.</p>	2020-05-12 08:44:35	2020-05-12 08:44:35	\N
3	User	web	<p>Has no adminisatrarive rights over the system. He / She has the only permission to view transaction.</p>	2020-05-12 08:45:29	2020-05-12 08:45:29	\N
\.


--
-- Data for Name: tbl_adt_user_access_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_adt_user_access_log (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, user_access_log_id, user_id, consumer_key, log_type, source_type, notes, record_version) FROM stdin;
\.


--
-- Data for Name: tbl_cmp_company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_cmp_company (companyid, companyname, companyaddress, companyemail, contactperson, companytype, addedby, ipaddress, created_at, updated_at, deleted_at) FROM stdin;
1	Switch Link	Ngong Rd Morning side offices	patrick.waweru@switchlinkafrica.co.ke 	Patrick Waweru	Adminstration	1	::1	2019-12-17 22:11:34	2019-12-17 22:11:34	\N
2	Transfast	Transfast offices	admin@transfast.com 	Transfast Admin	REMITTER	1	::1	2019-12-17 22:15:04	2019-12-17 22:15:04	\N
3	MoneyTrans	MoneyTrans offices	admin@moneytrans.com 	MoneyTrans Admin	REMITTER	1	::1	2019-12-17 22:15:33	2019-12-17 22:15:33	\N
4	Cash Express	Cash Express offices	admin@cashexpress.com 	Cash Express Admin	REMITTER	1	::1	2019-12-17 22:16:04	2019-12-17 22:16:04	\N
5	Uremit	Uremit offices	admin@uremit.com 	Uremit Admin	REMITTER	1	::1	2019-12-17 22:16:36	2019-12-17 22:16:36	\N
6	Xoom bank	Xoom offices	admin@xoom.com 	xoom Admin	BANK	1	::1	2019-12-17 22:17:10	2019-12-17 22:17:10	\N
7	Transfast Uganda	Transfast offices	admin@transfast.com 	Transfast Admin	REMITTER	1	::1	2019-12-17 22:17:41	2019-12-17 22:17:41	\N
8	Uremit Uganda	Uremit offices	admin@uremit.com 	Uremit Admin	REMITTER	1	::1	2019-12-17 22:17:58	2019-12-17 22:17:58	\N
\.


--
-- Data for Name: tbl_cmp_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_cmp_product (productid, serviceproviderid, product, productcode, description, charges, commission, transactiontype, status, addedby, modifiedby, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tbl_cus_blacklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_cus_blacklist (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, blacklist_id, partner_id, customer_idnumber, transaction_number, customer_name, mobile_number, blacklist_status, response, blacklist_source, remarks, blacklisted, blacklist_version, created_at, deleted_at, csv_filename, csv_header, csv_data) FROM stdin;
\N	\N	\N	\N	\N	\N	23038	\N	\N	\N	NAME	\N	FLAG	REASON	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23463	\N	\N	\N	UNSACCO ADVANCES UNSACC	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23464	\N	\N	\N	MOHAMED MALUKI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23465	\N	\N	\N	SAID SALIM	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23474	\N	\N	\N	SAID MOHAMED ALI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23475	\N	\N	\N	AUWAL OMAR 	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23476	\N	\N	\N	MAUREEN NJERI MAINA MAIN	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23477	\N	\N	\N	JAMAL AWADH OMAR 	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23489	\N	\N	\N	SAID ALI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23490	\N	\N	\N	DALLA ABDALLA MOHAMED	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23491	\N	\N	\N	MOHAMED ASHRAF YUSUF	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23617	\N	\N	\N	PATRICK PATRICK NJERU	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23568	\N	\N	\N	FREDRICK KARANJA NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23569	\N	\N	\N	MOHAMMED NOOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23570	\N	\N	\N	ABDULLAH SUWAILEH ABDULLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23571	\N	\N	\N	MOHAMMED NOOR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23572	\N	\N	\N	NAFISA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23573	\N	\N	\N	OMAR MOHAMED OMAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23574	\N	\N	\N	DAVID OLANDO 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23575	\N	\N	\N	MARTIN MWAURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23576	\N	\N	\N	DAVID OLANDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23577	\N	\N	\N	TIMA HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23578	\N	\N	\N	KHADIJA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23579	\N	\N	\N	ATHMAN ABDUL MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23580	\N	\N	\N	ABDALLA ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23581	\N	\N	\N	SOFIA BULE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23582	\N	\N	\N	ANTHONY DAVID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23583	\N	\N	\N	SAUDA AHMED ABDURAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23584	\N	\N	\N	ABDULMALIK MOHAMED MALIK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23585	\N	\N	\N	ABRAHIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23586	\N	\N	\N	BERNARD BENUA KARURI VERONICA WANJIKU BENUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23587	\N	\N	\N	RASHID MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23588	\N	\N	\N	KHAMISA MOHAMED KHAMIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23589	\N	\N	\N	IBRAHIM MBUTHIA GATHENYA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23590	\N	\N	\N	FRANCIS ANTHONY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23591	\N	\N	\N	ALI NASSOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23592	\N	\N	\N	SUDI ALI SALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23593	\N	\N	\N	CASTRO OMONDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23594	\N	\N	\N	KEVIN OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23595	\N	\N	\N	KHUZHEIMA MOHAMED ATHUMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23596	\N	\N	\N	SWALEH SEIF MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23597	\N	\N	\N	ABDUHAKIM SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23598	\N	\N	\N	SAAD MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23599	\N	\N	\N	AHMED SALIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23600	\N	\N	\N	ELDON ATHE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23601	\N	\N	\N	MOHAMAD JUMA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23602	\N	\N	\N	GLORIA CHELIMO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23603	\N	\N	\N	SWALEH NASIR SALAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23604	\N	\N	\N	ALVIN KOMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23605	\N	\N	\N	MONICA MAREI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23606	\N	\N	\N	MONICA MAREI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23742	\N	\N	\N	JAMLECK MUGO	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23711	\N	\N	\N	ALI AZALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23712	\N	\N	\N	GILBERT GILBERT	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23713	\N	\N	\N	JAMES OMARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23714	\N	\N	\N	HAMZA HAMZA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23715	\N	\N	\N	ALI KASSIM 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23716	\N	\N	\N	IRENE DWERO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23717	\N	\N	\N	LUIS NJOROGE WANJIKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23718	\N	\N	\N	THOMAS NAMBIKHWA MWIMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23719	\N	\N	\N	JANE NJERI NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23720	\N	\N	\N	MARIAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23721	\N	\N	\N	HASSAN SALIM BARIDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23722	\N	\N	\N	LILIAN LILIAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23723	\N	\N	\N	MOHAMED SADIQ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23724	\N	\N	\N	ABDULLAH SWALEH MWACHIDUDU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23725	\N	\N	\N	DAUD IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23726	\N	\N	\N	KASSIM YAKUB MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23727	\N	\N	\N	SAMUEL MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23728	\N	\N	\N	KELVIN WAWERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23729	\N	\N	\N	STEPHEN ODIPO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23730	\N	\N	\N	CHRISTOPHER NDUNGA MUTUKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23731	\N	\N	\N	MALACK ATINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23732	\N	\N	\N	LENAH EMILE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23733	\N	\N	\N	ESTHER AWITI ODUOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23734	\N	\N	\N	GRACE GATHONI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23735	\N	\N	\N	EMMY ATIENO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23736	\N	\N	\N	DOREEN KANYUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23737	\N	\N	\N	PERIS WANJIRU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23738	\N	\N	\N	ELIJAH MUREITHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23739	\N	\N	\N	HASSAN IDRIS MWANKALE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23740	\N	\N	\N	Ali Habib	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23741	\N	\N	\N	ABDUL FATAH YASIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23743	\N	\N	\N	JAMLECK MUGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23744	\N	\N	\N	SWALEH AHMED MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23745	\N	\N	\N	GABRIEL OCHOLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23746	\N	\N	\N	JAVAN DAVID MUNYOKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23747	\N	\N	\N	ABDALLA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23748	\N	\N	\N	THABIT AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23749	\N	\N	\N	JAWAHIR ISLAM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23750	\N	\N	\N	SALIM SAIZ SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23861	\N	\N	\N	ABDULFATAH YASIN	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23862	\N	\N	\N	JOEL TIMOTHY	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23863	\N	\N	\N	ZAINAB ABDALLAH OMAR OMAR	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23864	\N	\N	\N	ABDUL HAMID NASSOR 	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23865	\N	\N	\N	ABDELRAHMAN AHMED AL ABDELMAGID SHEHATA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23866	\N	\N	\N	ABDALLAH HASSAN ABDALLAH	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23867	\N	\N	\N	MUSTAFA MUSA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23828	\N	\N	\N	JAMAL AWADH OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23829	\N	\N	\N	UNSACCO ADVANCES UNSACCO ADVANCES	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23830	\N	\N	\N	ABDALLA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23831	\N	\N	\N	MOHAMED SALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23832	\N	\N	\N	MOHAMED HUSSEIN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23833	\N	\N	\N	Thureya Ahmed	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23834	\N	\N	\N	MONICA NGARUIYA\t	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23835	\N	\N	\N	ABDUL RAHMAN ABUBAKA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23836	\N	\N	\N	ABOUD ABDELLA ABOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23837	\N	\N	\N	MOHAMED ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23838	\N	\N	\N	ABDUL RAHMAN ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23839	\N	\N	\N	SHILA RASHID SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23840	\N	\N	\N	SALIM HALFAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23841	\N	\N	\N	ALI MOHAMMED NYOKA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23842	\N	\N	\N	REGINA WANJIKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23843	\N	\N	\N	GEORGE MUIRURI WACHIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23844	\N	\N	\N	ATHMAN MWINYIUSI ATHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23845	\N	\N	\N	DAISY NJERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23846	\N	\N	\N	SAID MAHMOUD SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23847	\N	\N	\N	MUHAMMAD OMAR MUHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23848	\N	\N	\N	ZAKIA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23849	\N	\N	\N	MOHAMED OMARI SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23850	\N	\N	\N	ZUHURA HUSSEIN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23851	\N	\N	\N	OSMAN TALIB OSMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23852	\N	\N	\N	RAYMOND MAGANGA MWAKIO24860.0254714553865xAML Veri	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23853	\N	\N	\N	HAMZA OMAR HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23854	\N	\N	\N	AMOUR ALI MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23855	\N	\N	\N	RAYMOND MAGANGA MWAKIO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23856	\N	\N	\N	ALI ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23857	\N	\N	\N	CARO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23858	\N	\N	\N	NAOMI MUKAMI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23859	\N	\N	\N	STEPHEN MWANGU RESA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23860	\N	\N	\N	JOSEPH KIMANI WANJIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23868	\N	\N	\N	MUSTAFA MUSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23869	\N	\N	\N	ABDALLAH HASSAN ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23870	\N	\N	\N	ABDELRAHMAN AHMED AL ABDELMAGID SHEHATA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23871	\N	\N	\N	ABDUL HAMID NASSOR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23872	\N	\N	\N	ZAINAB ABDALLAH OMAR OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23873	\N	\N	\N	MARTIN BENSON MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23874	\N	\N	\N	MARYAM SAID MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23875	\N	\N	\N	MUSA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23876	\N	\N	\N	SAID AHMAD ABOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23877	\N	\N	\N	SALIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23878	\N	\N	\N	HALIMA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24415	\N	\N	\N	FARID ABID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23901	\N	\N	\N	STEVE LTUMBESI LELEGWE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23938	\N	\N	\N	ASHA MONINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23939	\N	\N	\N	HENRY WAWERU NGIGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23940	\N	\N	\N	ABDUL AZIZ MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23941	\N	\N	\N	MARTIN MINJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23942	\N	\N	\N	RASHID SALIM MOYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23943	\N	\N	\N	HASSAN SHARIF ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23944	\N	\N	\N	ABDULRAHMAN HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23945	\N	\N	\N	HAWADOST MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23946	\N	\N	\N	ESTHER OCHIENG OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23947	\N	\N	\N	RYAN MWANGI RUNGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23948	\N	\N	\N	HABIB MWALIMU AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23949	\N	\N	\N	ALMAS MUHAMMAD IQBAL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23950	\N	\N	\N	MARIAM 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23951	\N	\N	\N	IRENE DWERO 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23952	\N	\N	\N	SAID MOHAMMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23953	\N	\N	\N	BAHIA SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23954	\N	\N	\N	EZEKIEL BUNGEI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23955	\N	\N	\N	WILLIAM JUMA MAKONGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23956	\N	\N	\N	DAVID GITHINJI KAMANDE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23957	\N	\N	\N	SARAH NYAMBURA KAGAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23958	\N	\N	\N	SAID SALIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23959	\N	\N	\N	RECHAEL WANJIRU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23960	\N	\N	\N	BARTIMAUS KIPCHIRCHIR KETTER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23961	\N	\N	\N	JOHN KINYANJUI MEMIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23962	\N	\N	\N	JAMES NGECHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23963	\N	\N	\N	ERIC ODHIAMBO ONYANGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23964	\N	\N	\N	PATRICIAH GATHURU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23965	\N	\N	\N	CHERYL KAHINGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23966	\N	\N	\N	ROSE NYAMBASI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23967	\N	\N	\N	SAMUEL NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23968	\N	\N	\N	ANDREW RAGEN OCHING	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23969	\N	\N	\N	BENJAMIN KIPROP TUM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23970	\N	\N	\N	DANSON MWACHIA NYALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23971	\N	\N	\N	HUSSEIN ABDALLAH HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23972	\N	\N	\N	HAMISI HAJI ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23973	\N	\N	\N	ABDALLA MATANO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23974	\N	\N	\N	DAVID MWANGI NGANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23975	\N	\N	\N	JUDY MURIUKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23976	\N	\N	\N	SYME MWANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23977	\N	\N	\N	KENNETH CHAMA KARUKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23978	\N	\N	\N	JOYCE WANTIRU KARANJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23979	\N	\N	\N	SOFIYA MWINYI KIBWANA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23980	\N	\N	\N	DANIEL OBIERO WATANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23981	\N	\N	\N	BEATRICE MUTHONI MASINDE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23982	\N	\N	\N	MWANAJUMA FADHILI KOMBO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23983	\N	\N	\N	JAMES KAMINDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23984	\N	\N	\N	JANEFFER NDUTA MBUGUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23985	\N	\N	\N	LUCY KEMUNTO AUGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23986	\N	\N	\N	SHADRACK KIPROTICH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24053	\N	\N	\N	HAWADOST MOHAMMED	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24054	\N	\N	\N	JUMA MUS A JUMA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24055	\N	\N	\N	BOGOA MOHAMED KASSIM	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24058	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24114	\N	\N	\N	OMAR MWARUWA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24115	\N	\N	\N	DR MOHAMED KHALID ZAFAR KHAN	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24121	\N	\N	\N	KEVIN MOBISA NTABO	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24095	\N	\N	\N	HANIFA OMAR NZAVIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24096	\N	\N	\N	PATRICK MWAKINYAMARI MWAZANG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24097	\N	\N	\N	RASHID SALIM 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24098	\N	\N	\N	FARIDA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24099	\N	\N	\N	FRED GITAU GAITHO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24100	\N	\N	\N	ANISA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24288	\N	\N	\N	OMARI HASSAN BAKARI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24207	\N	\N	\N	MOHAMUD ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24274	\N	\N	\N	GONZALO MARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24275	\N	\N	\N	ALI ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24276	\N	\N	\N	PETER OTACHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24277	\N	\N	\N	SWALHA OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24278	\N	\N	\N	SALIMA RASHID MUSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24279	\N	\N	\N	HASSAN ABDULLA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24280	\N	\N	\N	JOHN CUSHNY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24281	\N	\N	\N	John cushny	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24282	\N	\N	\N	KARAMA SWALEH KARAMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24283	\N	\N	\N	NAYIRAT MOHD DOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24284	\N	\N	\N	AMINA MUSTAFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24285	\N	\N	\N	OMAR MWARUWA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24286	\N	\N	\N	DR MOHAMED KHALID ZAFAR KHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24287	\N	\N	\N	BAKARI BAKARI MWAMAVUNE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24289	\N	\N	\N	OMARI HASSAN BAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24290	\N	\N	\N	MARTIN MWARA MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24291	\N	\N	\N	OTHUMAN HAMESA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24292	\N	\N	\N	Sara Maina	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24293	\N	\N	\N	MOHAMMED AMIN JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24294	\N	\N	\N	DIVINAH KEMUNTO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24295	\N	\N	\N	KELVIN MENDEMBO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24296	\N	\N	\N	GELLIAN ATIENO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24297	\N	\N	\N	GRACE SOROBI OINDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24298	\N	\N	\N	IRENE KWAM BOKA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24299	\N	\N	\N	TIMOTHY KAMURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24300	\N	\N	\N	MOHAMED IBRAHIM RAMADHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24301	\N	\N	\N	AISHA IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24302	\N	\N	\N	JOHN WAMBUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24303	\N	\N	\N	RICHARD MARTIN OLUOCH OGUTU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24304	\N	\N	\N	IBRAHIM AMADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24305	\N	\N	\N	HASSAN RASHID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24306	\N	\N	\N	MOHAMED ABDUL AZIZ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24307	\N	\N	\N	MOHAMMED ABDALLAH KAMALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24308	\N	\N	\N	FATMA SALIM RASHID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24309	\N	\N	\N	MOHAMMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24310	\N	\N	\N	JULLIET TUMAINI HARMATON	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24407	\N	\N	\N	YUNUS OMAR	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24311	\N	\N	\N	ISMAIL MZEE ISMAIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24312	\N	\N	\N	NAOMI NGENDO MOGOIYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24313	\N	\N	\N	PETER KIPKIRUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24314	\N	\N	\N	ABDULLAH B ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24315	\N	\N	\N	SALMAH ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24316	\N	\N	\N	ABEID SHEBA ABEID S 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24317	\N	\N	\N	EUMICE NJOKI NJUGUNA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24318	\N	\N	\N	JOSEPH MOIYAE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24319	\N	\N	\N	Mohamed Sheikh	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24320	\N	\N	\N	 ELIZABETH WAMBUI MICHAEL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24321	\N	\N	\N	Leah Kinyanjui	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24322	\N	\N	\N	ABDULRAHMAN ABDULLA SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24323	\N	\N	\N	MOHAMED SULEMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24324	\N	\N	\N	MOHAMED HASSAN MWAMBOGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24325	\N	\N	\N	AISHA MOHAMMED ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24383	\N	\N	\N	BASHI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24384	\N	\N	\N	SULEIMAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24385	\N	\N	\N	SWALEH SAID SALIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24386	\N	\N	\N	SHABAN IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24387	\N	\N	\N	HASSAN NOOR ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24388	\N	\N	\N	ESHA ABDULLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24389	\N	\N	\N	ABDI ADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24390	\N	\N	\N	MOHAMMED  ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24391	\N	\N	\N	CARO  	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24392	\N	\N	\N	JUMA MOHAMOUD JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24393	\N	\N	\N	KINGI KINGI OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24394	\N	\N	\N	gladys mbaire njeri	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24395	\N	\N	\N	Monica Nyambura	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24396	\N	\N	\N	Viona Wanjiru	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24397	\N	\N	\N	mohamed abdulahi	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24398	\N	\N	\N	HASSAN ABDULKADIR AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24399	\N	\N	\N	MUHAMAD DORY MUHAMAD YAKUB	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24400	\N	\N	\N	RABIYA ABDUL RAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24401	\N	\N	\N	SULEIMAN ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24402	\N	\N	\N	JOHN SILA MWITA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24403	\N	\N	\N	KENNEDY NJUGUNA NDUTA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24404	\N	\N	\N	THABIT MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24405	\N	\N	\N	SALIM JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24406	\N	\N	\N	OMAR MOHAMMED OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24408	\N	\N	\N	YUNUS OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24409	\N	\N	\N	ABUBAKAR ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24410	\N	\N	\N	ELIVER ACHIENG ELIJAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24411	\N	\N	\N	ABDUL RAHMAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24412	\N	\N	\N	DAVID KIMANI MWANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24413	\N	\N	\N	MUHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24414	\N	\N	\N	SWALHA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24416	\N	\N	\N	AHMED IBRAHIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24417	\N	\N	\N	YUSUF MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24418	\N	\N	\N	Mary Adema	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24619	\N	\N	\N	MOHAMMED AHMED AHMED	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24602	\N	\N	\N	MWANAKOMBO BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24603	\N	\N	\N	WINIFRED SENAJI VIJEDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24604	\N	\N	\N	GRACE OYANDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24605	\N	\N	\N	ANNA NDUUNE IKANDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24606	\N	\N	\N	JOHANNAH MWANIKI MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24607	\N	\N	\N	MOSES KARIUKI KURIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24608	\N	\N	\N	EVAH KUNGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24609	\N	\N	\N	JOYCE WAWEUR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24610	\N	\N	\N	SAMUEL MARIERA ONCHIRI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24611	\N	\N	\N	ANDREW KIKATU NZJULI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24612	\N	\N	\N	VERONICAH NYAGUTHII KIRAGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24613	\N	\N	\N	FELIX DENNIS KIPKEMBOI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24614	\N	\N	\N	JENIFFER KORIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24615	\N	\N	\N	MERCY MUNGAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24616	\N	\N	\N	FURMENSI KARATHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24617	\N	\N	\N	MARTIN WAURA MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24618	\N	\N	\N	FAHIMA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24620	\N	\N	\N	MOHAMMED AHMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24729	\N	\N	\N	LATIFA ALI MOHAMMED	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24718	\N	\N	\N	HALIMA ALI OSMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24831	\N	\N	\N	AHMED ABDIRAHMAN SHEIKH	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24917	\N	\N	\N	OMAR HASSAN ALI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24918	\N	\N	\N	AISHA ABDUL AZIZ	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24922	\N	\N	\N	ABDUL MOHAMED	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23056	\N	\N	\N	ALI ABOU ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24946	\N	\N	\N	ALI BAKARI SAID	\N	0	AML VERIFICATION	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24905	\N	\N	\N	ABDALLA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25016	\N	\N	\N	MICHAEL NJOGU NYAMBURA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25017	\N	\N	\N	MICHAELNJOGUNYAMBURA	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25001	\N	\N	\N	IBRAHIM AMIR JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25002	\N	\N	\N	ZUBEDA ABDALLA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25003	\N	\N	\N	ISSA MOHAMED OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25004	\N	\N	\N	MUSMAIL HASSAN MUHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25005	\N	\N	\N	ABDULRAHMAN HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25006	\N	\N	\N	ZAINAB FALAAH AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25007	\N	\N	\N	KHADIJA ABDUL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25008	\N	\N	\N	EDWARD KARANJA EDWARD KARANJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25009	\N	\N	\N	ZINGATIA MOHAMMED HAMZA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25010	\N	\N	\N	JOAN JERONO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25011	\N	\N	\N	SHAMSA SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25012	\N	\N	\N	SABRINA ABDUL RAHIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25013	\N	\N	\N	HASSAN MWANDANI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25014	\N	\N	\N	ABDIA HUSSEIN ALIO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25015	\N	\N	\N	FRANCISKURIAKIMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25018	\N	\N	\N	RANCIS KURIA KIMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25019	\N	\N	\N	BAKARI MURAMBA BA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25020	\N	\N	\N	ALI AHMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25021	\N	\N	\N	SALIM NKONO HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25022	\N	\N	\N	ESTHER PETER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25023	\N	\N	\N	HALIMA ALI OSMAN\t	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25024	\N	\N	\N	SAID MUHAMMED GOGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25025	\N	\N	\N	FATUMA MOHAMMED MUSTAFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25027	\N	\N	\N	OMAR BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25030	\N	\N	\N	EUNICE NJENGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25036	\N	\N	\N	JOSEPH NGIGE KAROKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25060	\N	\N	\N	KHALID JUMA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25061	\N	\N	\N	ABDULRAZAKI ABDULREHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25116	\N	\N	\N	ASHA MOHAMED ALI	\N	0	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25105	\N	\N	\N	AMINA ISMAIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25106	\N	\N	\N	HALIMA ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25107	\N	\N	\N	HANNAH WAWERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25108	\N	\N	\N	HAMADI SULEIMAN HARRY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25109	\N	\N	\N	MOHAMAD ANWAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25110	\N	\N	\N	AMINA MOHAMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25111	\N	\N	\N	TABASAM ABDUL HAMID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25112	\N	\N	\N	ABDI ADI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25113	\N	\N	\N	GHALIB BADRY GHALIB	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25114	\N	\N	\N	BRIAN TALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25115	\N	\N	\N	NIGEL LINDA ANNABELLE NIGEL LINDA ANNABELLE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25117	\N	\N	\N	ASHA MOHAMED MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25118	\N	\N	\N	JAMILA TUNZA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25119	\N	\N	\N	SALAME SALMIN SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25120	\N	\N	\N	MOHAMED ABUBAKAR MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25121	\N	\N	\N	ERIC WAWERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25122	\N	\N	\N	ALEX MANYARA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25123	\N	\N	\N	Zubeda Mohamed Mohamed Abdalla	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25124	\N	\N	\N	ALI HAMISI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25125	\N	\N	\N	BONIFACE MATHERI KIRIRAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25126	\N	\N	\N	STEPHEN SOITA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25127	\N	\N	\N	ALI ABDALLA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25128	\N	\N	\N	ALI ABDALLA ABDALLA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25129	\N	\N	\N	KHERMOHAMED MOHAMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25130	\N	\N	\N	ABDALLA MOHAMED ABDALLA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25131	\N	\N	\N	MOHAMMED SAID MOHAMMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25346	\N	\N	\N	JULIUS DAVID	\N	0	AML FAILURE	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25442	\N	\N	\N	SULEMAN MUHAMED	\N	0	AML FAILURE	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25364	\N	\N	\N	Mohamed Abdi	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25365	\N	\N	\N	SALAME SALAMIN AMIR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25366	\N	\N	\N	BASHIR MOHAMED MULI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25367	\N	\N	\N	SWALEH SALIM SWALEH	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25483	\N	\N	\N	MARY MARI KIONGO	\N	0	AML FAILURE	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25448	\N	\N	\N	DAVID MAROTICH	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25449	\N	\N	\N	AMINA MOHAMED LALI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25450	\N	\N	\N	BINT SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25532	\N	\N	\N	BANDA HAMISI BANDARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25533	\N	\N	\N	JOSEPH MASHA	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25617	\N	\N	\N	ISSA MOHAMMAD	\N	1	Not appearing on the Ofac List 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25618	\N	\N	\N	MARTIN KANYUA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25619	\N	\N	\N	Abdi rahmaan huseen Muuse	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25954	\N	\N	\N	JOHN CHARO 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26425	\N	\N	\N	SAID HASSAN SAIDI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26433	\N	\N	\N	JAMAL   MOHAMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26537	\N	\N	\N	SAKWA SULEIMAN	\N	0	Name flagged due to the name Suleiman same as the sanction however the spelling and his other names rules him out.	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26850	\N	\N	\N	HUSSEIN ALI	\N	0	NOT ON OFAC	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26889	\N	\N	\N	PETER KIMOTHO	\N	2	Paid erroneously	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26816	\N	\N	\N	SAID JUMA 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26891	\N	\N	\N	FRANCIS MITIRA	\N	1	Name flagged is FRANCIS same as the sanctioned individual however his other name rules him out since plus the sanctioned is Francois.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26892	\N	\N	\N	MOHAMED VIRANI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26895	\N	\N	\N	HAMISI ALI	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26972	\N	\N	\N	ANSWAR HAMAD MZEE	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27145	\N	\N	\N	MOHAMMAD AMIN ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27146	\N	\N	\N	JOSHUA OTIENO MAINA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27147	\N	\N	\N	MOHAMMED OMAR	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23633	\N	\N	\N	KENNETH ODHIAMBO OKOTH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23634	\N	\N	\N	JESSICA NDUKU KIKO MBALU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23635	\N	\N	\N	PATRICK​​ MWEU MUSIMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23636	\N	\N	\N	MATHENGE JAMES KANINI KEGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23637	\N	\N	\N	RUTH W MWANIKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23638	\N	\N	\N	SAMSON NDINDI NYORO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23639	\N	\N	\N	GIDEON SITELU KONCHELA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23640	\N	\N	\N	OWEN YAA BAYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23641	\N	\N	\N	RICHARD KEN CHONGA KITI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23642	\N	\N	\N	THUDDEUS KITHUA NZAMBIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23643	\N	\N	\N	DIDMUS WEKESA BARASA MUTUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23644	\N	\N	\N	CHRISANTUS WAMALWA WAKHUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23645	\N	\N	\N	BENJAMIN DALU STEPHEN TAYARI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23646	\N	\N	\N	ZACHARY KWENYA THUKU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23647	\N	\N	\N	AMOS MUHINGA KIMUNYAH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23648	\N	\N	\N	KIRUI JOSEPH LIMO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23649	\N	\N	\N	HILARY KIPLANG’AT KOSGEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23650	\N	\N	\N	JOHN MUNENE WAMBUGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23651	\N	\N	\N	ALI MENZA MBOGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23652	\N	\N	\N	FRED ODHIAMBO OUDA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23653	\N	\N	\N	SHAKEEL AHMED SHABBIR AHMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23654	\N	\N	\N	JOHN OLAGO ALUOCH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23655	\N	\N	\N	BENSON MAKALI MULU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23656	\N	\N	\N	NIMROD MBITHUKA MBAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23657	\N	\N	\N	DAVID MWALIKA MBONI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23658	\N	\N	\N	RACHAEL KAKI NYAMAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23659	\N	\N	\N	EDITH NYENZE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23660	\N	\N	\N	JIMMY NURU ONDIEKI ANGWENYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23661	\N	\N	\N	SHADRACK JOHN MOSE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23662	\N	\N	\N	YEGON BRIGHTON LEONARD	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23663	\N	\N	\N	MOSES KIPKEMBOI CHEBOI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23664	\N	\N	\N	MARWA KEMERO MAISORI KITAYAMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23665	\N	\N	\N	MATHIAS NYAMABE ROBI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23666	\N	\N	\N	FERDINARD KEVIN WANYONYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23667	\N	\N	\N	ABDI MUDE IBRAHIM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23668	\N	\N	\N	MOHAMED HIRE GARANE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23669	\N	\N	\N	AMIN DEDDY MOHAMED ALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23670	\N	\N	\N	SARAH PAULATA KORERE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23671	\N	\N	\N	PATRICK KARIUKI MARIRU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23672	\N	\N	\N	MARSELINO MALIMO ARBELLE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23673	\N	\N	\N	SHARIF ATHMAN ALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23674	\N	\N	\N	STANLEY MUIRURI MUTHAMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23675	\N	\N	\N	GENERALI NIXON KIPROTICH KORIR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23676	\N	\N	\N	JONAH MBURU MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23677	\N	\N	\N	MISHI JUMA KHAMISI MBOKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23678	\N	\N	\N	ENOCH WAMALWA​​ KIBUNGUCHY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23679	\N	\N	\N	PETER MUNGAI MWATHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23680	\N	\N	\N	JEREMIAH EKAMAIS LOMORUKAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23681	\N	\N	\N	CHRISTOPHER OMULELE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23682	\N	\N	\N	AYUB SAVULA ANGATIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23683	\N	\N	\N	KHATIB ABDALLAH MWASHETANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23684	\N	\N	\N	TITUS KHAMALA MUKHWANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23685	\N	\N	\N	JAPHET MIRITI​​ KAREKE MBIUKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23686	\N	\N	\N	VICTOR KIOKO MUNYAKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23687	\N	\N	\N	MICHAEL THOYAH KINGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23688	\N	\N	\N	GEORGE ALADWA OMWERA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27231	\N	\N	\N	MBARAK SWALEH MBARAK	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23689	\N	\N	\N	DANIEL KITONGA MAANZO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23690	\N	\N	\N	MOSES MALULU INJENDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23691	\N	\N	\N	AISHA JUMWA KARISA KATANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23692	\N	\N	\N	OMAR MOHAMED MAALIM HASSAN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23693	\N	\N	\N	BASHIR SHEIKH ABDULLAH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23694	\N	\N	\N	ADAN HAJI ALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23695	\N	\N	\N	ADAN HAJI YUSSUF	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23696	\N	\N	\N	JOHN MUCHIRI NYAGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23697	\N	\N	\N	MARY WAMAUA WAITHIRA NJOROGE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23698	\N	\N	\N	DAVID KANGOGO BOWEN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23699	\N	\N	\N	WILLIAM KIPKEMOI KISANG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23700	\N	\N	\N	JOSHUA MBITHI MWALYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23701	\N	\N	\N	GEOFFREY MAKOKHA ODANGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23702	\N	\N	\N	ANTHONY TOM OLUOCH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23703	\N	\N	\N	PETER KIMARI KIHARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23704	\N	\N	\N	RIGATHI GACHAGUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23705	\N	\N	\N	KASSIM SAWA TANDAZA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23706	\N	\N	\N	JUSTUS MURUNGA MAKOKHA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23707	\N	\N	\N	STEPHEN MUTINDA MULE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23708	\N	\N	\N	PATRICK MAKAU KING’OLA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23709	\N	\N	\N	CHARLES MURIUKI NJAGAGUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23710	\N	\N	\N	GEOFFREY KINGAGI MUTURI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23751	\N	\N	\N	MWAI KIBAKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23752	\N	\N	\N	DANIEL MOI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23753	\N	\N	\N	UHURU KENYATTA 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23754	\N	\N	\N	RAILA ODINGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23755	\N	\N	\N	WILLIAM RUTO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23756	\N	\N	\N	SAITOTI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23757	\N	\N	\N	EVANS KIDERO 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23758	\N	\N	\N	HASSAN JOHO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23759	\N	\N	\N	WILLIAM KABOGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23760	\N	\N	\N	FADINAND WAITITU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23761	\N	\N	\N	MIKE MBUVI 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23762	\N	\N	\N	RACHAEL SHEBESH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23763	\N	\N	\N	MUSALIA MUDAVADI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23764	\N	\N	\N	ABABU NAMWAMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23765	\N	\N	\N	JOHN MICHUKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23766	\N	\N	\N	PETER KENNETH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23767	\N	\N	\N	NAJIB BALALA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23768	\N	\N	\N	MARTHA KARUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23769	\N	\N	\N	WANGARI MATHAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23770	\N	\N	\N	BETH MUGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23771	\N	\N	\N	EUGENE WAMALWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23772	\N	\N	\N	JEREMIAH KIONI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23773	\N	\N	\N	GITHU MUIGAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23774	\N	\N	\N	KERIAKO TOBIKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23775	\N	\N	\N	WILLY MUTUNGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23776	\N	\N	\N	DAN KAZUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23777	\N	\N	\N	FRED MATIANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23778	\N	\N	\N	JUDY WAKHUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23779	\N	\N	\N	MWANGI KIUNJURI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23780	\N	\N	\N	HENRY ROTICH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23781	\N	\N	\N	HASSAN ARERO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23782	\N	\N	\N	JAMES MACHARIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23783	\N	\N	\N	WILLY BET	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23784	\N	\N	\N	JOSEPH NKAISSERY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23785	\N	\N	\N	AMINA MOHAMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23786	\N	\N	\N	MARGARET KOBIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23787	\N	\N	\N	FRED MATIANG'I	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23788	\N	\N	\N	CHARLES KETER	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23789	\N	\N	\N	JOHN MUNYES	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23790	\N	\N	\N	EUGENE WAMALWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23791	\N	\N	\N	RACHEAL OMAMO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23792	\N	\N	\N	MONICA JUMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23793	\N	\N	\N	SIMON CHELUGUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23794	\N	\N	\N	KERIAKO TOBIKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23795	\N	\N	\N	ADEN MOHAMMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23796	\N	\N	\N	JAMES MACHARIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23797	\N	\N	\N	JOSEPH MUCHERU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23798	\N	\N	\N	SICILY KARIUKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23799	\N	\N	\N	RASHID ACHESA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23800	\N	\N	\N	NAJIB BALALA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23801	\N	\N	\N	AMINA MOHAMMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23802	\N	\N	\N	FARIDA KARONEY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23803	\N	\N	\N	UKUR YATANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23804	\N	\N	\N	PETER MUNYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23805	\N	\N	\N	RAPHAEL TUJU  	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23806	\N	\N	\N	JUDY WAKHUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23807	\N	\N	\N	CLEOPA MAILU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23808	\N	\N	\N	KIEMA KILONZO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23809	\N	\N	\N	DAN KAZUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23810	\N	\N	\N	LAZARUS AMAYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23811	\N	\N	\N	PHYLLIS KANDIE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23812	\N	\N	\N	WILLY BETT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23813	\N	\N	\N	JACOB KAIMENYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23814	\N	\N	\N	ABABU NAMWAMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23815	\N	\N	\N	HUSSEIN DADHO 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23816	\N	\N	\N	CHRIS OBURE 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23817	\N	\N	\N	SIMON KACHAPIN 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23818	\N	\N	\N	KEN OBURA 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23819	\N	\N	\N	NELSON MARWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23820	\N	\N	\N	MICHAEL POWON	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23821	\N	\N	\N	PETER KABERIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23822	\N	\N	\N	JOSETTA MAKOBE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23823	\N	\N	\N	BELIO KISANG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23824	\N	\N	\N	LILIAN OMOLLO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23825	\N	\N	\N	TOROME SAITOTI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23826	\N	\N	\N	MOHAMED FAKI MWINYIHAJI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23827	\N	\N	\N	ISSA JUMA BOY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23879	\N	\N	\N	STEWART ​​ MADZAYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23880	\N	\N	\N	GOLICH JUMA WARIO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23881	\N	\N	\N	ANUAR LOITIPTIP	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23882	\N	\N	\N	​​JOHNES MWASHUSHE MWARUMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23883	\N	\N	\N	MOHAMED YUSUF HAJI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23884	\N	\N	\N	ABDULLAHI IBRAHIM ALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23885	\N	\N	\N	MOHAMED MAALIM MAHAMUD	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23886	\N	\N	\N	GODANA HARGURA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23887	\N	\N	\N	DULLO FATUMA ADAN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23888	\N	\N	\N	MITHIKA LINTURI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23889	\N	\N	\N	KITHURE KINDIKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23890	\N	\N	\N	PETER NJERU NDWIGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23891	\N	\N	\N	ENOCH KIIO WAMBUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23892	\N	\N	\N	BONIFACE MUTINDA KABAKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23893	\N	\N	\N	MUTULA KILONZO JUNIOR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23894	\N	\N	\N	PAUL GITHIOMI MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23895	\N	\N	\N	EPHRAIM MAINA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23896	\N	\N	\N	CHARLES KIBIRU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23897	\N	\N	\N	IRUNGU KANG’ATA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23898	\N	\N	\N	KIMANI WAMATANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23899	\N	\N	\N	MALACHY CHARLES EKAL IMANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23900	\N	\N	\N	SAMUEL POGHISIO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23902	\N	\N	\N	MICHAEL MALING’A MBITO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23903	\N	\N	\N	MARGARET KAMAR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23904	\N	\N	\N	KIPCHUMBA MURKOMEN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23905	\N	\N	\N	SAMSON CHERARKEY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23906	\N	\N	\N	GIDEON MOI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23907	\N	\N	\N	JOHN KINYUA NDERITU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23908	\N	\N	\N	SUSAN KIHIKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23909	\N	\N	\N	LEDAMA OLE KINA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23910	\N	\N	\N	PHILLIP SALAU MPAAYEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23911	\N	\N	\N	AARON KIPKIRUI CHERUIYOT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23912	\N	\N	\N	CHRISTOPHER LANGAT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23913	\N	\N	\N	CLEOPHAS WAKHUNGU MALALA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23914	\N	\N	\N	GEORGE KHANIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23915	\N	\N	\N	MOSES WETANGULA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23916	\N	\N	\N	SITSWILA AMOS WAKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23917	\N	\N	\N	JAMES ORENGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23918	\N	\N	\N	FREDRICK OTIENO OUTA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23919	\N	\N	\N	MOSES OTIENO KAJWANG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23920	\N	\N	\N	VACANT​​ 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23921	\N	\N	\N	SAM ONGERI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23922	\N	\N	\N	ERICK OKONGO MOGENI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23923	\N	\N	\N	JOHNSON​​ SAKAJA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23924	\N	\N	\N	DAVID WERE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23925	\N	\N	\N	IMMANUEL ICHOR IMANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23926	\N	\N	\N	JACKSON KIPTANUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23927	\N	\N	\N	DR LINDA MUSUMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23928	\N	\N	\N	KEN WAHOME MWATU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23929	\N	\N	\N	SAMUEL MWONGERA ARACHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23930	\N	\N	\N	JOEL KITILI, CHAIRPERSON	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23931	\N	\N	\N	AGNES MANTAINE PAREIYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23932	\N	\N	\N	LINUS GITAHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23933	\N	\N	\N	TITUS IBUI, CHAIRPERSON	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23934	\N	\N	\N	KHADIJA M. AWALE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23935	\N	\N	\N	PATRICK WOHORO NDOHHO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23936	\N	\N	\N	REGINA NDAMBUKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23937	\N	\N	\N	KATHLEEN OPENDA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24158	\N	\N	\N	FLORA MUTAHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24159	\N	\N	\N	JOE OWAKA AGER	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24198	\N	\N	\N	HASSAN JOHO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24199	\N	\N	\N	SALIM MVURYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24200	\N	\N	\N	AMASON KINGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24201	\N	\N	\N	DHADHO GODHANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24202	\N	\N	\N	FAHIM TWAHA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24203	\N	\N	\N	GRANTON  SAMBOJA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24204	\N	\N	\N	BUNOW KORANE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24205	\N	\N	\N	MOHAMED ABDI MOHAMUD	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24206	\N	\N	\N	ALI IBRAHIM ROBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24208	\N	\N	\N	MOHAMMED  KUTI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24209	\N	\N	\N	KIRAITU MURUNGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24210	\N	\N	\N	ONESMUS NJUKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24211	\N	\N	\N	MARTIN WAMBORA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24212	\N	\N	\N	CHARITY NGILU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24213	\N	\N	\N	ALFRED MUTUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24214	\N	\N	\N	KIVUTHA KIBWANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24215	\N	\N	\N	FRANCIS KIMEMIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24216	\N	\N	\N	MUTAHI KAHIGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24217	\N	\N	\N	ANNE WAIGURU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24218	\N	\N	\N	MWANGI WA IRIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24219	\N	\N	\N	FERDINAND WAITITU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24220	\N	\N	\N	JOSPHAT NANOK	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24221	\N	\N	\N	JOHN LONYANGAPUO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24222	\N	\N	\N	MOSES KASAINE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24223	\N	\N	\N	PATRICK KHAEMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24224	\N	\N	\N	JACKSON  MANDAGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24225	\N	\N	\N	ALEX TOLGOS	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24226	\N	\N	\N	STEPHEN  SANG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24227	\N	\N	\N	STANLEY KIPTIS	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24228	\N	\N	\N	NDIRITU MURIITHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24229	\N	\N	\N	LEE KINYANJUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24230	\N	\N	\N	SAMUEL TUNAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24231	\N	\N	\N	JOSEPH OLE LENKU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24232	\N	\N	\N	PAUL CHEPKWONY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24233	\N	\N	\N	JOYCE LABOSO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24234	\N	\N	\N	WYCLIFFE OPARANYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24235	\N	\N	\N	WILBER OTICHILO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24236	\N	\N	\N	WYCLIFFE WANGAMATI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24237	\N	\N	\N	SOSPETER OJAAMONG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24238	\N	\N	\N	CORNEL RASANGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24239	\N	\N	\N	ANYANG’ NYONG’O	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24240	\N	\N	\N	CYPRIAN AWITI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24241	\N	\N	\N	ZACHARIA OBADO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24242	\N	\N	\N	JAMES ONGWAE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24243	\N	\N	\N	JOHN NYAGARAMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24244	\N	\N	\N	WILLIAM KINGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24245	\N	\N	\N	FATUMA ACHANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24246	\N	\N	\N	KENNETH KAMTO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24247	\N	\N	\N	JIRE MOHAMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24248	\N	\N	\N	ABDULHAKIM ABOUD	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24249	\N	\N	\N	MAJALA MLAGHUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24250	\N	\N	\N	DAGAME ABDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24251	\N	\N	\N	AHMED ALI MUKTAR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24252	\N	\N	\N	OMAR MAALIM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24253	\N	\N	\N	SOLOMON GUBBO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24254	\N	\N	\N	ABDI ISSA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24255	\N	\N	\N	TITUS NTUCHIU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24256	\N	\N	\N	FRANCIS KAGWIMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24257	\N	\N	\N	DOROTHY MUCHUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24258	\N	\N	\N	DR. WATHE NZAU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24259	\N	\N	\N	FRANCIS MALITI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24260	\N	\N	\N	ADELINA NDETO MWAU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24261	\N	\N	\N	CECILIA MBUTHIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24262	\N	\N	\N	CAROLINE KARUGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24263	\N	\N	\N	PETER NDAMBIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24264	\N	\N	\N	AUGUSTINE MONYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24265	\N	\N	\N	DR. NYORO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24266	\N	\N	\N	PETER EKAI LOKOEL	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24267	\N	\N	\N	NICHOLAS ATUDONYANG’	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24268	\N	\N	\N	JOSEPH LEMARKAT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24269	\N	\N	\N	STANLEY TARUS	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24270	\N	\N	\N	DANIEL KIPROTICH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24271	\N	\N	\N	GABRIEL KOSGEY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24272	\N	\N	\N	YULITA  MITEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24273	\N	\N	\N	JACOB CHEPKWONY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24326	\N	\N	\N	JAMES MATHENGE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24327	\N	\N	\N	ERICK KORIR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24328	\N	\N	\N	ARUASA CHEPKIRUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24329	\N	\N	\N	MARTIN MOSHISHO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24330	\N	\N	\N	SUSAN  KIKWAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24331	\N	\N	\N	HILLARY BARCHOK	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24332	\N	\N	\N	PHILIP KUTIMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24333	\N	\N	\N	PATRICK SAISI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24334	\N	\N	\N	NGOME KIBANANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24335	\N	\N	\N	SOLOMON AKADAKE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24336	\N	\N	\N	WILSON OUMA ONYANGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24337	\N	\N	\N	MATHEWS OWILI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24338	\N	\N	\N	HAMILITON  ORATA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24339	\N	\N	\N	NELSON MWITA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24340	\N	\N	\N	ARTHUR GONGERA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24341	\N	\N	\N	AMOS NYARIBO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24342	\N	\N	\N	BRIGADIER ROBERT KARIUKI KIBOCHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24343	\N	\N	\N	BRIGADIER GEORGE OWINO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24344	\N	\N	\N	COLONEL JOSEPH MUTWII KIVUNZI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24345	\N	\N	\N	COLONEL THOMAS CHEPKUTO 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24346	\N	\N	\N	COLONEL ISAAC MUCHENDU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24347	\N	\N	\N	COLONEL DAVID AZANGU NGAIRA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24348	\N	\N	\N	COLONEL JOHN KIBASO WARIOBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24349	\N	\N	\N	COLONEL JOHN MWANGI 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24350	\N	\N	\N	COLONEL MOHAMED ABDALLA BADI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24351	\N	\N	\N	COLONEL ERIC KINUTHIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24352	\N	\N	\N	GENERAL MWATHETHE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24353	\N	\N	\N	WILLIAM KAMUREN CHIRCHIR CHEPKUT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24354	\N	\N	\N	SYLVANUS MARITIM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24355	\N	\N	\N	CORNELLY SEREM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24356	\N	\N	\N	SAMUEL ONUNGA​​ ATANDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24357	\N	\N	\N	JOHN WALTER OWINO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24358	\N	\N	\N	ONESMAS KIMANI NGUNJIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24359	\N	\N	\N	ABDI OMAR SHURIE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24360	\N	\N	\N	KULOW MAALIM HASSAN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24361	\N	\N	\N	JOSHUA CHEPYEGON KANDIE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24362	\N	\N	\N	WILLIAM CHEPTUMO KIPKIROR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24363	\N	\N	\N	NELSON KOECH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24364	\N	\N	\N	INNOCENT MOMANYI OBIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24365	\N	\N	\N	ZADOC ABEL OGUTU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24366	\N	\N	\N	MIRUKA ONDIEKI ALFAH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24367	\N	\N	\N	RONALD KIPROTICH TONUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24368	\N	\N	\N	BEATRICE PAULINE CHERONO​​ KONES	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24369	\N	\N	\N	JOHN OROO OYIOKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24370	\N	\N	\N	GIDEON OCHANDA OGOLLA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24371	\N	\N	\N	BEN GEORGE ORORI MOMANYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24372	\N	\N	\N	RAPHAEL BITTA SAUTI WANJALA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24373	\N	\N	\N	MOSES WEKESA MWAMBU MABONGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24374	\N	\N	\N	ALI WARIO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24375	\N	\N	\N	JAPHETH​​ KIPLANGAT MUTAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24376	\N	\N	\N	MUGAMBI MURWITHANIA RINDIKIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24377	\N	\N	\N	NICHOLAS SCOTT TINDI MWALE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24378	\N	\N	\N	JOSEPH H MAERO OYULA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24379	\N	\N	\N	MOSES NGUCHINE KIRIMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24380	\N	\N	\N	OMAR MWINYI SHIMBWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24381	\N	\N	\N	GIDEON KIMUTAI KOSKE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24382	\N	\N	\N	CHERANGANY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24419	\N	\N	\N	JOSHUA KUTUNY SEREM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24420	\N	\N	\N	WILSON KIPNGETICH KOGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24421	\N	\N	\N	BADY TWALIB BADY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24422	\N	\N	\N	PATRICK MUNENE NTWIGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24423	\N	\N	\N	MOHAMED DAHIR DUALE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24424	\N	\N	\N	PAUL SIMBA ARATI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24425	\N	\N	\N	JOHN/T KIARIE​​ WAWERU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24426	\N	\N	\N	MOSES K LESSONET	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24427	\N	\N	\N	ADAN KEYNAN WEHLIYE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24428	\N	\N	\N	BENJAMIN GATHIRU MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24429	\N	\N	\N	OWINO PAUL ONGILI BABU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24430	\N	\N	\N	JAMES MWANGI GAKUYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24431	\N	\N	\N	JULIUS MUSILI​​ MAWATHE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24432	\N	\N	\N	GEORGE THEURI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24433	\N	\N	\N	ALEXANDER KIMUTAI KIGEN KOSGEY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24434	\N	\N	\N	JEREMIAH OMBOKO MILEMBA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24435	\N	\N	\N	JOHANA NGENO KIPYEGON	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24436	\N	\N	\N	DR ROBERT PUKOSE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24437	\N	\N	\N	ABDIKHAIM OSMAN MOHAMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24438	\N	\N	\N	WILBERFORCE OJIAMBO OUNDO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24439	\N	\N	\N	SAID BUYA HIRIBAE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24440	\N	\N	\N	TEDDY NGUMBAO MWAMBIRE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24441	\N	\N	\N	ADEN BARE DUALE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24442	\N	\N	\N	ALI WARIO GUYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24443	\N	\N	\N	JOSEPH NDUATI NGUGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24444	\N	\N	\N	GATUNDU NORTH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24445	\N	\N	\N	ANNIE WANJIKU KIBEH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24446	\N	\N	\N	MOSES KIARIE KURIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24447	\N	\N	\N	ELISHA OCHIENG ODHIAMBO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24448	\N	\N	\N	ROBERT GICHIMU GITHINJI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24449	\N	\N	\N	MARTHA WANGARI WANJIRA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24450	\N	\N	\N	GABRIEL KAGO MUKUHA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24451	\N	\N	\N	CHARLES GUMINI GIMOSE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24452	\N	\N	\N	GEORGE​​ PETER OPONDO KALUMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24453	\N	\N	\N	CYPRIAN KUBAI IRINGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24454	\N	\N	\N	IGEMBE NORTH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24455	\N	\N	\N	RICHARD MAORE MAOKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24456	\N	\N	\N	JOHN PAUL MWIRIGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24457	\N	\N	\N	SOPHIA ABDI NOOR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24458	\N	\N	\N	BENARD MASAKA SHINALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24459	\N	\N	\N	HASSAN ODA HULUFO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24460	\N	\N	\N	ABDI KOROPU TEPO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24461	\N	\N	\N	FRANCIS MUNYUA WAITITU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24462	\N	\N	\N	JAMES GITHUA KAMAU WAMACUKURU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24463	\N	\N	\N	EVE AKINYI OBARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24464	\N	\N	\N	JAMES LUSWETI MUKWE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24465	\N	\N	\N	MARK LOMUNOKOL	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24466	\N	\N	\N	JOSHUA KIVINDA​​ KIMILU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24467	\N	\N	\N	ELIJAH MEMUSI KANCHORY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24468	\N	\N	\N	PERIS PESI TOBIKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24469	\N	\N	\N	JOSEPH WATHIGO MANJE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24470	\N	\N	\N	METITO JUDAH KATOO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24471	\N	\N	\N	GEORGE RISA SUNKUYIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24472	\N	\N	\N	PAUL KAHINDI KATANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24473	\N	\N	\N	YUSUF HASSAN ABDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24474	\N	\N	\N	ALICE MUTHONI WAHOME	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24475	\N	\N	\N	ATHANAS MISIKO WAFULA WAMUNYINYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24476	\N	\N	\N	CLEMENT MUTURI KIGANO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24477	\N	\N	\N	FABIAN KYULE MULI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24478	\N	\N	\N	SAMWEL MOROTO CHUMEL	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24479	\N	\N	\N	OSCAR KIPCHUMBA SUDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24480	\N	\N	\N	ANDREW ADIPO OKUOME	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24481	\N	\N	\N	MERCY WANJIKU GAKUYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24482	\N	\N	\N	CHARLES ONG’ONDO WERE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24483	\N	\N	\N	ROBERT MBUI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24484	\N	\N	\N	JAMES KIPKOSGEI MURGOR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24485	\N	\N	\N	JUBILEE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24486	\N	\N	\N	KEIYO SOUTH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24487	\N	\N	\N	DANIEL KIPKOGEI RONO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24488	\N	\N	\N	SWARUP RANJAN MISHRA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24489	\N	\N	\N	CHRISTOPHER ASEKA WANGAYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24490	\N	\N	\N	PAUL KOINANGE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24491	\N	\N	\N	JUDE L KANGETHE NJOMO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24492	\N	\N	\N	ERASTUS​​ KIVASU NZIOKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24493	\N	\N	\N	DANIEL KAMUREN TUITOEK	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24494	\N	\N	\N	SILAS KIPKOECH TIREN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24495	\N	\N	\N	FRANCIS KURIA KIMANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24496	\N	\N	\N	VINCENT KIPKURUI TUWEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24497	\N	\N	\N	QALICHA GUFU WARIO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24498	\N	\N	\N	SULEIMAN DORI RAMADHANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24499	\N	\N	\N	FRED KAPONDI CHESEBE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24500	\N	\N	\N	PATRICK AYIECHO OLWENY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24501	\N	\N	\N	ANTHONY GITHIAKA KIAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24502	\N	\N	\N	BENJAMIN JOMO WASHIALI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24503	\N	\N	\N	JOHNSON MANYA NAICCA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24504	\N	\N	\N	ABDULLSWAMAD SHERIFF NASSIR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24505	\N	\N	\N	VINCENT​​ MUSYOKA MUSAU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24506	\N	\N	\N	ANDREW MWADIME	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24507	\N	\N	\N	JOSPHAT KABINGA WACHIRA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24508	\N	\N	\N	GIDEON MUTEMI MULYUNGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24509	\N	\N	\N	PAUL MUSYIMI NZENGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24510	\N	\N	\N	CHARLES NGUSYA NGUNA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24511	\N	\N	\N	JAYNE NJERI WANJIRU KIHARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24512	\N	\N	\N	DAVID GIKARIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24513	\N	\N	\N	SAMUEL ARAMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24514	\N	\N	\N	SAKWA JOHN BUNYASI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24515	\N	\N	\N	ALFRED KIPTOO KETER	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24516	\N	\N	\N	LEMANKEN ARAMAT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24517	\N	\N	\N	RICHARD MOITALEI OLE KENTA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24518	\N	\N	\N	KOREI​​ OLE LEMEIN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24519	\N	\N	\N	GABRIEL KOSHAL TONGOYO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24520	\N	\N	\N	EMMANUEL WANGWE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24521	\N	\N	\N	JEREMIAH NG’AYU KIONI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24522	\N	\N	\N	MARTIN PETERS OWINO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24523	\N	\N	\N	GEORGE MACHARIA KARIUKI GK	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24524	\N	\N	\N	CHARITY KATHAMBI CHEPKWONY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24525	\N	\N	\N	FRANCIS CHACHU GANYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24526	\N	\N	\N	ABDUL RAHIM DAWOOD	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24527	\N	\N	\N	JOASH NYAMACHE NYAMOKO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24528	\N	\N	\N	JOSHUA ADUMA OWUOR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24529	\N	\N	\N	MOHAMED ALI MOHAMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24530	\N	\N	\N	JARED ODOYO OKELO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24531	\N	\N	\N	RICHARD NYAGAKA​​ TONGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24532	\N	\N	\N	EZEKIEL MACHOGU OMBAKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24533	\N	\N	\N	TOM MBOYA ODEGE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24534	\N	\N	\N	MARTIN DERIC NGUNJIRI WAMBUGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24535	\N	\N	\N	MICHAEL MWANGI MUCHIRA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24536	\N	\N	\N	DAVID NJUGUNA KIARAHO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24537	\N	\N	\N	JAMES GICHUKI MUGAMBI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24538	\N	\N	\N	DAVID LOSIAKOU PKOSING	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24539	\N	\N	\N	WILLIAM KAMOTI MWAMKALE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24540	\N	\N	\N	PAUL OTIENDE AMOLLO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24541	\N	\N	\N	LILIAN ACHIENG GOGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24542	\N	\N	\N	PAUL ODALO MAK’ OJUANDO ABUOR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24543	\N	\N	\N	KIPRUTO MOI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24544	\N	\N	\N	ISAAC WAIHENYA NDIRANGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24545	\N	\N	\N	KAJWANG’ TOM JOSEPH FRANCIS	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24546	\N	\N	\N	SIMON NGANGA KINGARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24547	\N	\N	\N	ERIC MUCHANGI NJIRU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24548	\N	\N	\N	ALFRED AGOI MASADIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24549	\N	\N	\N	CALEB AMISI LUYAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24550	\N	\N	\N	DIDO ALI RASO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24551	\N	\N	\N	LENTOI JONI L JACKSON​​ LEKUMONTARE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24552	\N	\N	\N	ALOIS MUSA LENTOIMAGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24553	\N	\N	\N	JOSEPHINE NAISULA LESUUDA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24554	\N	\N	\N	JAMES WAMBURA NYIKAL	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24555	\N	\N	\N	JUSTUS GESITO MUGALI M’MBAYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24556	\N	\N	\N	PETER LOCHAKAPONG	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24557	\N	\N	\N	BENARD KIPSENGERET KOROS	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24558	\N	\N	\N	JOHN WALUKE KOYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24559	\N	\N	\N	DOMINIC KIPKOECH KOSKEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24560	\N	\N	\N	KATHURI MURUNGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24561	\N	\N	\N	SILVANUS OSORO ONYIEGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24562	\N	\N	\N	CALEB KIPKEMEI KOSITANY	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24563	\N	\N	\N	CHARLES KANYI NJAGUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24564	\N	\N	\N	MILLIE GRACE AKOTH ODHIAMBO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24565	\N	\N	\N	MBADI JOHN NG’ONGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24566	\N	\N	\N	SAMUEL KINUTHIA GACHOBE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24567	\N	\N	\N	JUNET SHEIKH NUH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24568	\N	\N	\N	PETER FRANCIS MASARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24569	\N	\N	\N	AHMED BASHANE GAAL	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24570	\N	\N	\N	NAOMI NAMSI SHABAN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24571	\N	\N	\N	JAMES GICHUHI MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24572	\N	\N	\N	EDWARD OKU KAUNYA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24573	\N	\N	\N	GEOFFREY OMUSE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24574	\N	\N	\N	GEORGE GITONGA MURUGARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24575	\N	\N	\N	PATRICK KIMANI WAINAINA JUNGLE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24576	\N	\N	\N	WILLIAM KAMKET KASSAIT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24577	\N	\N	\N	JOSPHAT GICHUNGE​​ MWIRABUA KABEABEA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24578	\N	\N	\N	JOHN KANYUITHIA MUTUNGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24579	\N	\N	\N	JULIUS KIPBIWOT	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24580	\N	\N	\N	DAVID ESELI SIMIYU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24581	\N	\N	\N	JANET JEPKEMBOI SITIENEI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24582	\N	\N	\N	JOHN LODEPE NAKARA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24583	\N	\N	\N	LOKIRU ALI​​ MOHAMMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24584	\N	\N	\N	CHRISTOPHER DOYE NAKULEU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24585	\N	\N	\N	EKOMWA LOMENEN JAMES	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24586	\N	\N	\N	DANIEL EPUYO NANOK	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24587	\N	\N	\N	CHRISTOPHER ODHIAMBO KARANI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24588	\N	\N	\N	JAMES OPIYO WANDAYI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24589	\N	\N	\N	MARK OGOLLA NYAMITA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24590	\N	\N	\N	ERNEST OGESI KIVAI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24591	\N	\N	\N	JONES MWAGOGO MLOLWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24592	\N	\N	\N	RASHID KASSIM AMIN	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24593	\N	\N	\N	AHMED ABDISALAN IBRAHIM	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24594	\N	\N	\N	MOHAMUD SHEIKH MOHAMMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24595	\N	\N	\N	AHMED KOLOSH MOHAMED	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24596	\N	\N	\N	BERNARD ALFRED WEKESA SAMBU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24597	\N	\N	\N	DANIEL WANYAMA SITATI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24598	\N	\N	\N	VINCENT KEMOSI MOGAKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24599	\N	\N	\N	TIMOTHY WANYONYI WETANGULA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24600	\N	\N	\N	DANSON MWASHAKO MWAKUWONA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24601	\N	\N	\N	CHARLES MUTAVI KILONZO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24786	\N	\N	\N	\N	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24964	\N	\N	\N	JOSEPH NGIGE KAROKI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25026	\N	\N	\N	ABDIKADIR BUKAR	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25028	\N	\N	\N	JOHN NDEGWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25029	\N	\N	\N	PETER MUCHIRI KABIRU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25031	\N	\N	\N	BONAVENTURE AKUMU RAPANDO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25032	\N	\N	\N	MARY SYOKAU PETER	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25033	\N	\N	\N	DOROTHY MALLEON	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25034	\N	\N	\N	PHILOMENA MKALUMA MWAWASI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25035	\N	\N	\N	ERIC MUGAMBI 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25037	\N	\N	\N	DENIS MWAURA NANDWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25038	\N	\N	\N	RASHID SHIKASON MAGOGO 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25039	\N	\N	\N	MARY WAMAHIGA KANGETHE 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25040	\N	\N	\N	FERDINAND ORJIAWWUNA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25041	\N	\N	\N	NANCY NJENGA 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25042	\N	\N	\N	IRENE OBAGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25043	\N	\N	\N	ISAAC WAINANA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25044	\N	\N	\N	BENARD WATHITHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25045	\N	\N	\N	SALMA JUMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25046	\N	\N	\N	THOMAS MAKOKHA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25047	\N	\N	\N	SHEILAH AHADI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25048	\N	\N	\N	JANET ORUOCH	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25049	\N	\N	\N	SUDI MARIAKA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25050	\N	\N	\N	ESTHER IRUNGU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25051	\N	\N	\N	PATRICK NGATIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25052	\N	\N	\N	SAMUEL MATINDI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25053	\N	\N	\N	CATHERINE WANDERA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25054	\N	\N	\N	NICHOLAS ERASTO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25055	\N	\N	\N	MARGARET NAFWA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25056	\N	\N	\N	JANET NJENGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25057	\N	\N	\N	MARY RAUTE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25058	\N	\N	\N	AGNES KAPARO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25059	\N	\N	\N	JOSHWA GATHURA 	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25133	\N	\N	\N	HARRYSN NJOROGE MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25134	\N	\N	\N	BETHWEL NJORE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25135	\N	\N	\N	ANDREW ODHIAMBO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25136	\N	\N	\N	ANABEL ALUORA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25137	\N	\N	\N	JOHN KIOI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25139	\N	\N	\N	Brian Muthoki	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25140	\N	\N	\N	FAITH CHAO INJAGA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25141	\N	\N	\N	PULKERIA ASERE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25142	\N	\N	\N	CAROLYN WANGARI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25143	\N	\N	\N	SAMUEL IKAMA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25144	\N	\N	\N	REDFERN OMWAMBA NYANGECHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25146	\N	\N	\N	Martin kavinguha	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25148	\N	\N	\N	ANN MUTUA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25149	\N	\N	\N	MATHAN ORIENGO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25150	\N	\N	\N	ANNE MUTILE MUTISO	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25151	\N	\N	\N	BETHWEL NJORE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25152	\N	\N	\N	EVERLYNE GITAU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25154	\N	\N	\N	ALEX MUTHUA WANJIRU	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25155	\N	\N	\N	BONFACE MUJURI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25156	\N	\N	\N	JOSEPH KAMAU KIMINDIRI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25157	\N	\N	\N	ALICE MONARI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25158	\N	\N	\N	DANIEL MAKORI OGECHI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25159	\N	\N	\N	JAMES ZEBEDEE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25160	\N	\N	\N	ERICK MWANGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25161	\N	\N	\N	FARIDA MUSES	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25162	\N	\N	\N	GRACE MUKAMI NGUGI	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25163	\N	\N	\N	BRIAN MUDHUNE	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25175	\N	\N	\N	ESTHER MACHARIA	\N	2	\N	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25180	\N	\N	\N	MARGARET NDUNGU	\N	2	Double paid MPESA client	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25382	\N	\N	\N	QUEEN ELIZABETH AWUOR OCHIENG	\N	2	Txn cancelled but client was sent funds	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25383	\N	\N	\N	SAMMY MIGWI	\N	2	Txn cancelled but client was sent funds	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25384	\N	\N	\N	INSTYLE DESIGN FURNITURE LTD	\N	2	Txn cancelled but client was sent funds	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25462	\N	\N	\N	JENNIFER NANDWA JUMA	\N	2	Client was paid but transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25463	\N	\N	\N	JACK OGOLA JUMA	\N	2	Client was paid but transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25562	\N	\N	\N	MUSA ABDU MOHAMED	\N	2	Client was paid but transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25630	\N	\N	\N	JOSPHAT MUNYOKI	\N	2	Client was paid but transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25631	\N	\N	\N	MAGARATE NDUNGU	\N	2	Client was paid but transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26427	\N	\N	\N	PAUL KARANJA MUCHIRI	\N	2	Client was double paid	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26969	\N	\N	\N	ESTHER ABUGA	\N	2	Client was double paid bank deposit	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26970	\N	\N	\N	AMOS JUMA ODIWOUR	\N	2	Was paid after transaction was cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26971	\N	\N	\N	JOHN NDICHU THUO	\N	2	Double paid client on 09/12/2019	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26994	\N	\N	\N	OMAR BAKARI	\N	2	Double paid on 27/04/2018 Tel 0714839008	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27153	\N	\N	\N	STEVE LTUMBESI LELEGWE	\N	2	PEP	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27160	\N	\N	\N	ALI MOHAMUD MAHAMED	\N	2	Governor Marsabit Constituency	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27209	\N	\N	\N	HARISON KARUGU KIMANI	\N	2	Double paid client on 27/11/2019	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27249	\N	\N	\N	SARAPHINAH ABUBAKER ODHIAMBO	\N	2	Customer was paid but transaction cancelled	\N	\N	t	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23039	\N	\N	\N	JOSHUA MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23040	\N	\N	\N	SAID HASHIM SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23041	\N	\N	\N	CHRISTINE MUTHONI MWANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23042	\N	\N	\N	STEPHEN MBUTHIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23043	\N	\N	\N	MIKE GITUMA MBAE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23044	\N	\N	\N	CRISPUS SHAKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23045	\N	\N	\N	OMAR HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23046	\N	\N	\N	MARIAM MOHAMUD HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23047	\N	\N	\N	RAMADHAN HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23048	\N	\N	\N	ABDALLAH SALIM ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23049	\N	\N	\N	ABDIYA ADAN HUSEN HUSEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23050	\N	\N	\N	AHMED MOHAMED ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23051	\N	\N	\N	AMINA MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23052	\N	\N	\N	ZAHRA MOHAMED AMIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23053	\N	\N	\N	SHEIKHA AHMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23054	\N	\N	\N	JUMA ABDULLA RANDANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23055	\N	\N	\N	AHMED YUNUS HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23057	\N	\N	\N	AHMED ALI HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23058	\N	\N	\N	MOHAMED ABDUL MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23059	\N	\N	\N	SAID AHMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23060	\N	\N	\N	AMAL MOHAMED ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23061	\N	\N	\N	AHMED ALI HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23062	\N	\N	\N	JOHN PAUL OKUMU BWANA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23063	\N	\N	\N	ABDALLA OMAR ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23064	\N	\N	\N	PAMELLA ACHIENG ACHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23065	\N	\N	\N	KENNEDY OMONDI ONYANGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23066	\N	\N	\N	HAKIMA IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23067	\N	\N	\N	MUSA ATHMAN MUSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23068	\N	\N	\N	RASHID ISMAIL RASHID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23069	\N	\N	\N	ABDI MUHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23070	\N	\N	\N	NJUGUNA JUDY WANJIRU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23071	\N	\N	\N	ABDILLAHI ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23072	\N	\N	\N	ABDALLAH SALIM ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23073	\N	\N	\N	MOHAMED ABDULLAHI YUSSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23074	\N	\N	\N	ALI IDRIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23075	\N	\N	\N	BASHIR ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23076	\N	\N	\N	MOHAMED ABDULLAHI YUSSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23077	\N	\N	\N	SWALEH IBRAHIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23078	\N	\N	\N	MOHAMED SALIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23079	\N	\N	\N	JAMAL SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23080	\N	\N	\N	AMINA SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23081	\N	\N	\N	SAKINAH ABDUL RAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23082	\N	\N	\N	FAATIMA MOHAMED ABDUL MUTTALIB	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23083	\N	\N	\N	ASHA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23084	\N	\N	\N	HAMZA HAMZA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23085	\N	\N	\N	ISSA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23086	\N	\N	\N	ABDALA AHMAD SAAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23087	\N	\N	\N	ALI ABBAS ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23088	\N	\N	\N	JUMA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23089	\N	\N	\N	STEPHEN KARANJA NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23090	\N	\N	\N	MARIAM HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23091	\N	\N	\N	ABDALLA SHARIFF AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23092	\N	\N	\N	ABUBAKAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23093	\N	\N	\N	MUSA ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23094	\N	\N	\N	YASSIN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23095	\N	\N	\N	HASINA ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23096	\N	\N	\N	ABDURAHMAN AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23097	\N	\N	\N	SALIMAH ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23098	\N	\N	\N	RASHID SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23099	\N	\N	\N	ABDUL KARIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23100	\N	\N	\N	ABDIRAHMAN HAJI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23101	\N	\N	\N	RAMADHAN ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23102	\N	\N	\N	KEZA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23103	\N	\N	\N	GRACE KANZE JILANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23104	\N	\N	\N	JAMES MURIITHI KINYUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23105	\N	\N	\N	ROSE WAIRIMU MAMUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23106	\N	\N	\N	SAMSON MBUGUA NDUNGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23107	\N	\N	\N	HASSAN OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23108	\N	\N	\N	PRISCILLA NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23109	\N	\N	\N	PATRICK WACHIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23110	\N	\N	\N	RAMADHANI HAJI ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23111	\N	\N	\N	KASSIM ALWY KASSIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23112	\N	\N	\N	SHAHID KHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23113	\N	\N	\N	EUSTACE MURIITHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23114	\N	\N	\N	SWALEH IBRAHIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23115	\N	\N	\N	MOHAMED ABDULLAHI YUSSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23116	\N	\N	\N	BASHIR ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23117	\N	\N	\N	ALI IDRIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23118	\N	\N	\N	ABDILLAHI ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23119	\N	\N	\N	MBARAK MOHAMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23120	\N	\N	\N	LEIA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23121	\N	\N	\N	ABDALLA MBARU ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23122	\N	\N	\N	MBARAK OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23123	\N	\N	\N	ALI MOHAMMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23124	\N	\N	\N	ABDUL ABDALLA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23125	\N	\N	\N	ELIZABETH NJAU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23126	\N	\N	\N	ABDALLAH AWADH OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23127	\N	\N	\N	MOHAMMED HAJI OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23128	\N	\N	\N	MOHAMED ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23129	\N	\N	\N	BURHAN AWEISS BURHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23130	\N	\N	\N	ABDALLA JUMA ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23131	\N	\N	\N	AMINA MOHAMMED MASSEMO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23132	\N	\N	\N	HASSAN SHERIJ ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23133	\N	\N	\N	NUR SALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23134	\N	\N	\N	MOHAMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23135	\N	\N	\N	MAIMUNA ABDUL RAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23136	\N	\N	\N	JAMIE ARTHUR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23137	\N	\N	\N	MANAL SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23138	\N	\N	\N	HUSSEIN MOHAMED HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23139	\N	\N	\N	ALI MOHAMED BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23140	\N	\N	\N	AMINA MOHAMED FAMAU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23141	\N	\N	\N	JOSEPH GIKONYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23142	\N	\N	\N	ALI AHMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23143	\N	\N	\N	OMARI JAMES	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23144	\N	\N	\N	YUSUF MOHAMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23145	\N	\N	\N	MOHAMED ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23146	\N	\N	\N	RAHMA ABDUL MALIK KHAMIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23147	\N	\N	\N	MOHAMED HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23148	\N	\N	\N	KHAMISI MOHAMMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23149	\N	\N	\N	ABDUL RAHIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23150	\N	\N	\N	ATHAMAN RASHID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23151	\N	\N	\N	SWALEH IBRAHIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23152	\N	\N	\N	KASSIM AHMED KASSIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23153	\N	\N	\N	SALIM ASHUR SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23154	\N	\N	\N	MOHAMMED HASSAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23155	\N	\N	\N	KADRA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23156	\N	\N	\N	AHMED ABDALLAH RAMADHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23157	\N	\N	\N	HABIBA SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23158	\N	\N	\N	MOHAMMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23159	\N	\N	\N	MOHAMMAD ISSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23160	\N	\N	\N	MOHAMAD SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23161	\N	\N	\N	HUZEYMA IBRAHIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23162	\N	\N	\N	SAID MOHAMED MZEE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23163	\N	\N	\N	IBRAHIM ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23164	\N	\N	\N	ABDALLAH SALIM RASHID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23165	\N	\N	\N	MOHAMMED AMIN ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23166	\N	\N	\N	IMA HAMISI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23167	\N	\N	\N	SHAFI ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23168	\N	\N	\N	SALIM MOHAMMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23169	\N	\N	\N	MOHAMED SAID ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23170	\N	\N	\N	JAMAL MOHAMED NASSER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23171	\N	\N	\N	KHADIJA FADHIL MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23172	\N	\N	\N	OMARI SAMBI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23173	\N	\N	\N	ABDUL WAHAB HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23174	\N	\N	\N	MARYAM MOHAMAD ABED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23175	\N	\N	\N	HUSSEIN MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23176	\N	\N	\N	ABDUL AHMAD MANSURI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23177	\N	\N	\N	SALIM YUSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23178	\N	\N	\N	MARYAM ABDUL RAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23179	\N	\N	\N	IBRAHIM ABDULKADIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23180	\N	\N	\N	MOHAMED HASSAN KILUMEE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23181	\N	\N	\N	AMANAT MAHMOUD MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23182	\N	\N	\N	ABDU ABDULRAB SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23183	\N	\N	\N	TABU MAMBO MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23184	\N	\N	\N	HAMMAD YACOUB HAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23185	\N	\N	\N	ALI MOHMMAD ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23186	\N	\N	\N	HAIFA ABDULLAH HUSSAIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23187	\N	\N	\N	OMARA MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23188	\N	\N	\N	ANTHONY NDIRANGU MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23189	\N	\N	\N	JUMA ABDALLA RAMADHA MBETO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23190	\N	\N	\N	AHMED MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23191	\N	\N	\N	HUSSEIN ASSAD AHMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23192	\N	\N	\N	TAWFIQ MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23193	\N	\N	\N	TAWFIQ MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23194	\N	\N	\N	DAVID MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23195	\N	\N	\N	RAHMA MOHAMED HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23196	\N	\N	\N	TWALIB ABUD SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23197	\N	\N	\N	ABDUL HAKIM JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23198	\N	\N	\N	MOHAMED OMAR HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23199	\N	\N	\N	HUSSEIN ABDUL KELIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23200	\N	\N	\N	KHALIFA ABUBAKAR KHALIFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23201	\N	\N	\N	ABUBAKAR M ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23202	\N	\N	\N	HALIMA JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23203	\N	\N	\N	MOHAMED SAID ABOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23204	\N	\N	\N	MOYO HASSAN SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23205	\N	\N	\N	HUSSEIN ALI HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23206	\N	\N	\N	MAUA OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23207	\N	\N	\N	ADAN HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23208	\N	\N	\N	ASHA ABDI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23209	\N	\N	\N	AHMED MOHAMMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23210	\N	\N	\N	CHRISTOPHER WANDERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23211	\N	\N	\N	NURU SAID MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23212	\N	\N	\N	AWATIF SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23213	\N	\N	\N	JUMA HAMISI JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23214	\N	\N	\N	ZARATUN AHMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23215	\N	\N	\N	FARAJ . FARAJ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23216	\N	\N	\N	MR MOHAMMED MUSTAFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23217	\N	\N	\N	JUMA JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23218	\N	\N	\N	JUMA MUSA JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23219	\N	\N	\N	ABBAS ABDULRAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23220	\N	\N	\N	SAID HASSAN MAHAMUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23221	\N	\N	\N	MUTEMBEI K KEVIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23222	\N	\N	\N	BERLINE OGILLO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23223	\N	\N	\N	FRANK MURIMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23224	\N	\N	\N	CHARTY HURUMA CHARO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23225	\N	\N	\N	FAROUQ ALI KATANA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23226	\N	\N	\N	FATMA FATMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23227	\N	\N	\N	DUNCAN KING ORI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23228	\N	\N	\N	ANNA KAVATA MUTYOTA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23229	\N	\N	\N	AMINA MOHAMMED OSMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23230	\N	\N	\N	LUIS MJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23231	\N	\N	\N	HEMED ABDULRAHMAN HEMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23232	\N	\N	\N	HAMZA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23233	\N	\N	\N	CATHERINE MGOI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23234	\N	\N	\N	CHRIS MUUO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23235	\N	\N	\N	FRANCIS KIPCHUMBA LA ARUSEI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23236	\N	\N	\N	BAHATI ALI BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23237	\N	\N	\N	SAMSON ONCHARI MATOKE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23238	\N	\N	\N	NANCY NYAWIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23239	\N	\N	\N	HANNAH WANJIKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23240	\N	\N	\N	DICKSON MULWALE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23241	\N	\N	\N	AMINA AHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23242	\N	\N	\N	KHALED ABDUL RAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23243	\N	\N	\N	MUSMAIL HASSAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23244	\N	\N	\N	ABDULLAHI MOHAMMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23245	\N	\N	\N	RASHID MWALIMU SALIMU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23246	\N	\N	\N	ABDULRAHIM IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23247	\N	\N	\N	ATHMAN SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23248	\N	\N	\N	FAHD SAID MOHAMMED AWADH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23249	\N	\N	\N	JUMA HAMAD JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23250	\N	\N	\N	ABDI HAMID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23251	\N	\N	\N	FAUZI ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23252	\N	\N	\N	ALI SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23253	\N	\N	\N	SHEIKHA IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23254	\N	\N	\N	ASHA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23255	\N	\N	\N	AMINA IBRAHIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23256	\N	\N	\N	ABDULLAH HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23257	\N	\N	\N	MOHAMUD ABDI ADEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23258	\N	\N	\N	FATUMA MOHAMED ISSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23259	\N	\N	\N	ALI SALIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23260	\N	\N	\N	BASHIR ABDULMUJIB	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23261	\N	\N	\N	LATIFA ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23262	\N	\N	\N	RASHIDA ISSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23263	\N	\N	\N	NANCY MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23264	\N	\N	\N	DANIEL MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23265	\N	\N	\N	OMARI MUSA OMARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23266	\N	\N	\N	BAKARI ALI SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23267	\N	\N	\N	HAMAD HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23268	\N	\N	\N	LATIFA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23269	\N	\N	\N	ABBAS MOHAMMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23270	\N	\N	\N	HASSAN HOI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23271	\N	\N	\N	FADHILA MOHAMED BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23272	\N	\N	\N	ABDALLA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23273	\N	\N	\N	OMAR ABDUL RAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23274	\N	\N	\N	SHAUGI SAID MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23275	\N	\N	\N	SALIM FAIZ SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23276	\N	\N	\N	ISSA ALI ISSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23277	\N	\N	\N	MOHAMMED BABU MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23278	\N	\N	\N	HALIMA MUHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23279	\N	\N	\N	ABDULHAKIM AMIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23280	\N	\N	\N	HANNAH WACERA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23281	\N	\N	\N	MUHAMMADI SHEIKH ISSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23282	\N	\N	\N	OMAR HASSAN BOKOKO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23283	\N	\N	\N	MAHMUD SHEE IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23284	\N	\N	\N	MOHAMED HAMADI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23285	\N	\N	\N	SALIM ABDULRAHMAN AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23286	\N	\N	\N	SOFIA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23287	\N	\N	\N	ALI RAMADHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23288	\N	\N	\N	SWALEHE MOHAMED NZINGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23289	\N	\N	\N	HASSAN ABUBAKAR EDARUS HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23290	\N	\N	\N	SAID KALELI MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23291	\N	\N	\N	HALIMA MUSTAFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23292	\N	\N	\N	BAKARI ZUBERI BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23293	\N	\N	\N	MARIAMU HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23294	\N	\N	\N	BAKARI ZUBERI BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23295	\N	\N	\N	JOE MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23296	\N	\N	\N	JOSEPH GITHIRI MUKORA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23297	\N	\N	\N	MWANAKOMBO JUMA ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23298	\N	\N	\N	GODFREY OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23299	\N	\N	\N	ZIPPORAH WANGARI MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23300	\N	\N	\N	HELENA MAKOKHA ACHANDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23301	\N	\N	\N	ABDUL RAHMAN OMAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23302	\N	\N	\N	SAIDI MUHAMMED GOGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23303	\N	\N	\N	ALI HAMZA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23304	\N	\N	\N	RUBY MOHAMMED HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23305	\N	\N	\N	CECILIA MARIFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23306	\N	\N	\N	Monica Ngaruiya	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23307	\N	\N	\N	ABDALLAH ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23308	\N	\N	\N	THUREYA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23309	\N	\N	\N	COLEEN GATHAMBI NYAGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23310	\N	\N	\N	WILSON NJOROGE MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23311	\N	\N	\N	HALIMA KHALID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23312	\N	\N	\N	ALI JUMA KHAMIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23313	\N	\N	\N	LUNI SALIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23314	\N	\N	\N	ABDULHAKIM NASSOR SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23315	\N	\N	\N	SABRINA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23316	\N	\N	\N	MARYAMA MOHAMAD ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23317	\N	\N	\N	PAULINE ONJOLO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23318	\N	\N	\N	HEMED SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23319	\N	\N	\N	HAMIDA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23320	\N	\N	\N	HALIMA MOHAMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23321	\N	\N	\N	ALI MOHAMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23322	\N	\N	\N	HARUN ABDALLA MUHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23323	\N	\N	\N	MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23324	\N	\N	\N	ELIZABETH MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23325	\N	\N	\N	ABDI HUSSEIN MAHAMUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23326	\N	\N	\N	YUSUF ISLAM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23327	\N	\N	\N	JUSTUS ONWONGA MOSOTI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23328	\N	\N	\N	NELLIE NJOKI NGANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23329	\N	\N	\N	ABDUL MOHAMED OBO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23330	\N	\N	\N	COSMAS M M MSENGETI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23331	\N	\N	\N	ERICK OMONDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23332	\N	\N	\N	VICTOR KINYANJUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23333	\N	\N	\N	JOSEPH IRUNGU WANJAU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23334	\N	\N	\N	MOHAMMED KHALFAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23335	\N	\N	\N	ANN WARUKIRA WANGARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23336	\N	\N	\N	HUSNA HASSAN MAHMOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23337	\N	\N	\N	NGOGE KEPHA MOGIRE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23338	\N	\N	\N	DAVID KIARIE NJENGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23339	\N	\N	\N	MILLIE ASUMPTA BUSOLO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23340	\N	\N	\N	HASAN MOHAMED MWAMIYA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23341	\N	\N	\N	MILLICENT AOKO OGOTT	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23342	\N	\N	\N	IMMACULATE AKOTH OLOO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23343	\N	\N	\N	KATINKA FRUZSINA STRAUS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23344	\N	\N	\N	TABITHA WACKE WAHINY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23345	\N	\N	\N	RIZIKI WASSO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23346	\N	\N	\N	MARY WANGUI MUCHUGIAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23347	\N	\N	\N	MARGARET ODUK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23348	\N	\N	\N	FLORA KARANJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23349	\N	\N	\N	REUBEN MUKURIA NGURE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23350	\N	\N	\N	LHANNA GLENN SANTOS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23351	\N	\N	\N	SAYEDYASIRALLY QADRI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23352	\N	\N	\N	AHMED SALIM SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23353	\N	\N	\N	PETER KIARIE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23354	\N	\N	\N	BA JULIUS MWANGOVYA RIMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23355	\N	\N	\N	SOLOMAN NYALLE NBAJI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23356	\N	\N	\N	SAMUEL KAMAU KANGETHE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23357	\N	\N	\N	STEPHEN KAMAU THUO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23358	\N	\N	\N	DORCAS MUTULA MBENEKA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23359	\N	\N	\N	FAITH WANJIKU 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23360	\N	\N	\N	ANNE NDUKU WILLIAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23361	\N	\N	\N	EHAMA ALI FERUNZI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23362	\N	\N	\N	LILY KIPLANGAT 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23363	\N	\N	\N	WISDOM MWALUMA MWANDOE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23364	\N	\N	\N	JANE LUMUMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23365	\N	\N	\N	YUSUF SAID YUSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23366	\N	\N	\N	ABDULSAMAD ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23367	\N	\N	\N	MOHAMMED ABDUL AZIZ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23368	\N	\N	\N	MOHAMED MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23369	\N	\N	\N	JOSEPH MWAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23370	\N	\N	\N	TWALIB AMIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23371	\N	\N	\N	MARIAM OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23372	\N	\N	\N	ABDILLAH ALI SALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23373	\N	\N	\N	SELINA DELA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23374	\N	\N	\N	SAID KASSIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24106	\N	\N	\N	WARDA BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23375	\N	\N	\N	MOHAMED ABDISHAKUR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23376	\N	\N	\N	HAMIDA ABDULATIF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23377	\N	\N	\N	SWALEH MOHAMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23378	\N	\N	\N	RAMADHAN ABDALLA RAMADHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23379	\N	\N	\N	SAID SULEMAN MWANGUO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23380	\N	\N	\N	SULEIMAN KASSIM SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23381	\N	\N	\N	ADAM HUSSEIN ADAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23382	\N	\N	\N	ALI KASSIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23383	\N	\N	\N	RABIYA MOHAMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23384	\N	\N	\N	SULEIMAN MOHAMMED MAZULO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23385	\N	\N	\N	SAID ABDALLA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23386	\N	\N	\N	ALIYE MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23387	\N	\N	\N	HAMZA ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23388	\N	\N	\N	FAHIMA SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23389	\N	\N	\N	HALMA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23390	\N	\N	\N	MOHAMED HAMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23391	\N	\N	\N	PAUL WAFULA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23392	\N	\N	\N	MARTIN MWAURA MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23393	\N	\N	\N	ALFRED JOHN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23394	\N	\N	\N	ALI MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23395	\N	\N	\N	AMINA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23396	\N	\N	\N	JOHN WAMBUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23397	\N	\N	\N	SAMUEL MBUGUA KIHIU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23398	\N	\N	\N	ABDUL RAHMAN SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23399	\N	\N	\N	SALAH SALIM ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23400	\N	\N	\N	FREDRICK NDUMBI FREDRICK NDUMBI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23401	\N	\N	\N	SOFIA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23402	\N	\N	\N	SAID MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23403	\N	\N	\N	MARTIN FRED MANYURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23404	\N	\N	\N	SADA SULEIMAN SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23405	\N	\N	\N	SAIDI MOHAMED LUBUGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23406	\N	\N	\N	MUSA MKALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23407	\N	\N	\N	BERNARD MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23408	\N	\N	\N	MOHAMMAD MWINYI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23409	\N	\N	\N	MOHAMED BREK MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23410	\N	\N	\N	MUZNA ABDUL AZIZ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23411	\N	\N	\N	SWALEH MOHAMED MWACHIKUVI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23412	\N	\N	\N	OMAR ISLAM AWADH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23413	\N	\N	\N	TWALIB ABUD SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23414	\N	\N	\N	ROSE JAIRO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23415	\N	\N	\N	MOHAMED SAID SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23416	\N	\N	\N	BRUCE AUSTINE AUSTINE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23417	\N	\N	\N	ABDUL FATAH BUNU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23418	\N	\N	\N	ZEINAB MOHAMED FADHIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23419	\N	\N	\N	NASIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23420	\N	\N	\N	JOSEPH KIHIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23421	\N	\N	\N	HASSAN AHMED RAFIU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23422	\N	\N	\N	MUSA MOHAMED BOGA MUSA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23423	\N	\N	\N	MARIAM RAMADAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23424	\N	\N	\N	ABDALLAH AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23425	\N	\N	\N	MOHAMED CHIBINGU ABDURAHMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23426	\N	\N	\N	SALIM BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23427	\N	\N	\N	MARTIN NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23428	\N	\N	\N	EDMOND KIMALEL MISOI NGETICH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23429	\N	\N	\N	JOHN KARURU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23430	\N	\N	\N	FARID MOHAMMED KHAMISS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23431	\N	\N	\N	ABED MBARAK ABED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23432	\N	\N	\N	HAMAD RASHID ZIZI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23433	\N	\N	\N	MATHENGE MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23434	\N	\N	\N	MARGARET WAGIO MUKONYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23435	\N	\N	\N	PETER MUNIU KANGETHE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23436	\N	\N	\N	MOHAMED HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23437	\N	\N	\N	ASMAA AHMED ISLAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23438	\N	\N	\N	ALI ABDULRAHMAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23439	\N	\N	\N	AMINA ALI MHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23440	\N	\N	\N	SIHAM MOHAMED SHEIKH AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23441	\N	\N	\N	MWANAKOMBO JUMA JUMA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23442	\N	\N	\N	DIANA OLANDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23443	\N	\N	\N	MOHAMED ABUBAKAR EBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23444	\N	\N	\N	FERUZ ABDUL RAHIM MOHAMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23445	\N	\N	\N	RAHMA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23446	\N	\N	\N	STELLAH NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23447	\N	\N	\N	STELLA NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23448	\N	\N	\N	KARAMA SAID MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23449	\N	\N	\N	BARNABAS OCHIENG OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23450	\N	\N	\N	ABDALLA SWALEH ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23451	\N	\N	\N	SAID KANDY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23452	\N	\N	\N	TWAHIR SHARIFF HASSAN ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23453	\N	\N	\N	MOHAMED HASSAN DZENGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23454	\N	\N	\N	RASHIDA ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23455	\N	\N	\N	ABDUL AZIZI SALIM THOYA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23456	\N	\N	\N	LATIFA ABDUL MALIK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23457	\N	\N	\N	FAIZA AHMED ABDULREHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23458	\N	\N	\N	ABDALLAH OMAR ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23459	\N	\N	\N	ANA MARIA RODRIGUEZ BARROSO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23460	\N	\N	\N	OUSMAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23461	\N	\N	\N	YUSUF SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23462	\N	\N	\N	MWAKA OMAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23466	\N	\N	\N	SOPHIA BAKHER ABDALLA ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23467	\N	\N	\N	OMAR AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23468	\N	\N	\N	RAHMA AHMED SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23469	\N	\N	\N	MOSES MURIMI WAWIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23470	\N	\N	\N	SIMON GATHECA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23471	\N	\N	\N	ABDALLA MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23472	\N	\N	\N	KHALFAN KHALFAN KHALFAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23473	\N	\N	\N	stella njoroge	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23478	\N	\N	\N	JAMAL AWADH OMAR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23479	\N	\N	\N	MAUREEN NJERI MAINA MAIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23480	\N	\N	\N	AUWAL OMAR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23481	\N	\N	\N	SAID MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23482	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23483	\N	\N	\N	SAID SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23484	\N	\N	\N	MOHAMED MALUKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23485	\N	\N	\N	UNSACCO ADVANCES UNS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23486	\N	\N	\N	SWALEH IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23487	\N	\N	\N	KHAMIS MOHAMED SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23488	\N	\N	\N	MOHAMED SHIMOI AMIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23492	\N	\N	\N	MAUREEN NJERI MAINA MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23493	\N	\N	\N	HASSAN SALIMU HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23494	\N	\N	\N	RAHIMA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23495	\N	\N	\N	FATMA ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23496	\N	\N	\N	ABDALLA AHMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23497	\N	\N	\N	ALI JAFFER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23498	\N	\N	\N	MWANAMWINYI ABDALLA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23499	\N	\N	\N	MERCY MERCY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23500	\N	\N	\N	ALI OMAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23501	\N	\N	\N	BELLA MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23502	\N	\N	\N	OMAR MAZIWA OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23503	\N	\N	\N	SAADIA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23504	\N	\N	\N	PETER KARANJA NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23505	\N	\N	\N	HASSAN MOHAMMED OMALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23506	\N	\N	\N	BAKARI SALIM HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23507	\N	\N	\N	MAULIDI HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23508	\N	\N	\N	SULEIMAN MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23509	\N	\N	\N	BAYAZA MOHAMED IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23510	\N	\N	\N	MOHAMED ABDALLA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23511	\N	\N	\N	CYNTHIA CYNTHIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23512	\N	\N	\N	ABDALLA MOHAMED ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23513	\N	\N	\N	HAFIDH MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23514	\N	\N	\N	NASSIM SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23515	\N	\N	\N	MAIMUNA ABUBAKAR AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23516	\N	\N	\N	AMINA ALI SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23517	\N	\N	\N	MOHAMED BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23518	\N	\N	\N	AZIZ ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23519	\N	\N	\N	HAMIDA HAMISI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23520	\N	\N	\N	SALIM HAMISI SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23521	\N	\N	\N	ABDULLAH ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23522	\N	\N	\N	SALIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23523	\N	\N	\N	ALI MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23524	\N	\N	\N	SALIM SWALEH MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23525	\N	\N	\N	HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23526	\N	\N	\N	ABDIFATAH AHMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23527	\N	\N	\N	SHAFFI ABUBAKAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23528	\N	\N	\N	MOHAMED SHEBANI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23529	\N	\N	\N	 ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23530	\N	\N	\N	MOHAMED AHMED MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23531	\N	\N	\N	RASHID MOHAMMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23532	\N	\N	\N	AHMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23533	\N	\N	\N	GEORGE NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23534	\N	\N	\N	MOHAMED IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23535	\N	\N	\N	HASSAN HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23536	\N	\N	\N	OMAR ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23537	\N	\N	\N	TAJIRI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23538	\N	\N	\N	MOHAMED ABDUL RAHMAN BASHIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23539	\N	\N	\N	ALI SALIM MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23540	\N	\N	\N	MOHAMED ABDUL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23541	\N	\N	\N	ABDI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23542	\N	\N	\N	HALIMA MUSTAFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23543	\N	\N	\N	MARIAMU HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23544	\N	\N	\N	MOHAMED ABDUL RAHMAN BASHIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23545	\N	\N	\N	DOREEN SERENGE KIGALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23546	\N	\N	\N	RAMATHAN AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23547	\N	\N	\N	ASHA ABDI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23548	\N	\N	\N	ESTHER KAVITHE SIMON	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23549	\N	\N	\N	ASIA SWALEHE TANDARA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23550	\N	\N	\N	STEPHEN MWANGI NJENGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23551	\N	\N	\N	MUHAMMAD AWADH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23552	\N	\N	\N	ALI HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23553	\N	\N	\N	AZIZA YUSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23554	\N	\N	\N	FARAJ FARAJ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23555	\N	\N	\N	MOHAMED ABDI SHEIKH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23556	\N	\N	\N	FATUMA MOHAMED HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23557	\N	\N	\N	PRISCILLAH WAMBUI CHEGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23558	\N	\N	\N	RAMADHAN ALI RAMADHAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23559	\N	\N	\N	ABDI ABDULLAH MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23560	\N	\N	\N	HASSAN SALIM ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23561	\N	\N	\N	HASHIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23562	\N	\N	\N	HASSAN ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23563	\N	\N	\N	PURITY WAIRIMU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23564	\N	\N	\N	JOHN MUTUA SILA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23565	\N	\N	\N	IBRAHIM SULEIMAN SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23566	\N	\N	\N	MUHAMMAD OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23567	\N	\N	\N	AHMED OMAR HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23607	\N	\N	\N	ABDUL RAHMAN SALIM HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23608	\N	\N	\N	NANCY MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23609	\N	\N	\N	IBRAHIM MOHAMED HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23610	\N	\N	\N	BAKARI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23611	\N	\N	\N	TIMOTHY WAFULA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23612	\N	\N	\N	JOSEPH KIARIE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23613	\N	\N	\N	AHMED HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23614	\N	\N	\N	MOHAMED SALIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23615	\N	\N	\N	ABDUL RAHMAN HADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23616	\N	\N	\N	LUCY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23618	\N	\N	\N	PATRICK PATRICK NJERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23619	\N	\N	\N	OMARI HASSAN BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23620	\N	\N	\N	EBRAHIM MOHAMED SHARIFF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23621	\N	\N	\N	MAKAME CHUMMU KITONA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23622	\N	\N	\N	AHMED HUSSEIN MOHAMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23623	\N	\N	\N	IBRAHIM ABDULLAHI IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23624	\N	\N	\N	AMINA ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23625	\N	\N	\N	AMINA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23626	\N	\N	\N	HADIJA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23627	\N	\N	\N	MARTHA WANGUI MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23628	\N	\N	\N	ASHA RAMADHANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23629	\N	\N	\N	MOHAMMAD ABDILLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23630	\N	\N	\N	FRANCIS JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23631	\N	\N	\N	UBAH YASSIN AHMEND	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23632	\N	\N	\N	AHMED AHMED KHEIR ABDALLA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23987	\N	\N	\N	TERESIA WANGUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23988	\N	\N	\N	KENNEDY NJOROGE KAMANDE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23989	\N	\N	\N	TERESIA MWINZI WILLIAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23990	\N	\N	\N	VERONICAH LARVINE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23991	\N	\N	\N	DAMARIS KISESE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23992	\N	\N	\N	PAUL MWANGI MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23993	\N	\N	\N	IBRAHIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23994	\N	\N	\N	TOM NJOGU RANJI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23995	\N	\N	\N	IBRAHIM KATHEE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23996	\N	\N	\N	ROSE WAMBUI MUREU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23997	\N	\N	\N	BERNARD GACHIMU KABIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23998	\N	\N	\N	MWANAHAMISI RAMADHANI ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	23999	\N	\N	\N	PAUL WAIRAGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24000	\N	\N	\N	DAVID WANYONYIL NDALILA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24001	\N	\N	\N	VINCENT MATOKE RASUGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24002	\N	\N	\N	PETER MWAI KIMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24003	\N	\N	\N	MUNISA ABDULKADIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24004	\N	\N	\N	ABDIA NUROW ALIO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24005	\N	\N	\N	MOHAMED TALEB IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24006	\N	\N	\N	SILA JOHN MULI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24007	\N	\N	\N	SULEIMAN MWINYI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24008	\N	\N	\N	RIZIKI SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24009	\N	\N	\N	JOY MALONZA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24010	\N	\N	\N	ANNE KIUMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24011	\N	\N	\N	DANIEL OUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24012	\N	\N	\N	ABDALLAH SAID ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24013	\N	\N	\N	EUNICE MUTHONI NJUGUNA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24014	\N	\N	\N	NYAMBURA TABITHA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24015	\N	\N	\N	SIMON WARIO GITU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24016	\N	\N	\N	JONAH MBUGUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24017	\N	\N	\N	MATTHEW KIMUYU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24018	\N	\N	\N	ANNASTASIA KAMWITHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24019	\N	\N	\N	GIDEON KIPLANGAT TONUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24020	\N	\N	\N	TRUSILA MUROKA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24021	\N	\N	\N	LILA KIWELU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24022	\N	\N	\N	RACHAEL WANGUI NJERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24023	\N	\N	\N	ALI SHEE BWIJO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24024	\N	\N	\N	FAITH MANGAA MOINGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24025	\N	\N	\N	NAPHTALI OMONDI OLONDE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24026	\N	\N	\N	DIANA MUKIRI NJERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24027	\N	\N	\N	RUTH NJAMBI KAGWI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24028	\N	\N	\N	GREGORY ODUOR ONYANGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24029	\N	\N	\N	FRANKLIN YAMUMO IRERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24030	\N	\N	\N	JECINTA WANGARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24031	\N	\N	\N	CATHERINE NDERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24032	\N	\N	\N	LYDIA WANJIRU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24033	\N	\N	\N	RAPHAEL NANDWA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24034	\N	\N	\N	SUSAN NJUGUNA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24035	\N	\N	\N	LUCIA ROSELYNE NABWIRE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24036	\N	\N	\N	NEWTONE ANANGWE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24037	\N	\N	\N	EMILY M ODERO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24038	\N	\N	\N	SIMON MAIRURA SAGANA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24039	\N	\N	\N	CARO 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24040	\N	\N	\N	 \t ABDALLAH MDZOMBA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24041	\N	\N	\N	ABDALLAH MDZOMBA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24042	\N	\N	\N	MOHAMMED ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24043	\N	\N	\N	HAWAA ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24044	\N	\N	\N	SHAEB MBARAK BEREK MBARAK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24045	\N	\N	\N	CHRISTINE ORUMOI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24046	\N	\N	\N	\tMOHAMMED ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24047	\N	\N	\N	MOHAMED ASHRAF YUSUF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24048	\N	\N	\N	SAID ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24049	\N	\N	\N	AUWAL OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24050	\N	\N	\N	MOHAMMED JIRA MALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24051	\N	\N	\N	DICKSON KAMAU NDIRITU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24052	\N	\N	\N	AHMED SAID MOHAMUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24056	\N	\N	\N	BOGOA MOHAMED KASSIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24057	\N	\N	\N	HAWADOST MOHAMMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24059	\N	\N	\N	AMINA HASSAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24060	\N	\N	\N	SAUMU MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24061	\N	\N	\N	PATRICK GITHINJI KIBUCHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24062	\N	\N	\N	JUMA MUS A JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24063	\N	\N	\N	MOHAMMED ALMASI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24064	\N	\N	\N	KHALID TWALIB	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24065	\N	\N	\N	CATHERINE KARIMI MONGARE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24066	\N	\N	\N	MOHAMMED HAFIJ MISTRY USMAN MISTRY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24067	\N	\N	\N	ANTONY NGIGI NDUNGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24068	\N	\N	\N	ANWAR AWADH KARAMA AWADH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24069	\N	\N	\N	SADAM BASHIR HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24070	\N	\N	\N	IBRAHIM KATHEE 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24071	\N	\N	\N	 JOEL MWATHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24072	\N	\N	\N	NANCY NRUNGAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24073	\N	\N	\N	FEISAL TAHA NOOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24074	\N	\N	\N	KENNETH OTIENO OPONDO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24075	\N	\N	\N	AGNES MAWIA KIILU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24076	\N	\N	\N	JOSEPH OKONGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24077	\N	\N	\N	RUKIA SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24078	\N	\N	\N	PAMELA NYANGANSA ONDIPA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24079	\N	\N	\N	FAITH CHEMUTAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24080	\N	\N	\N	MICHAEL ARINGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24081	\N	\N	\N	ERIC MATOKE ASIAGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24082	\N	\N	\N	AHMED ABDALLAH MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24083	\N	\N	\N	CAROLINE NJOKI MIRINGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24084	\N	\N	\N	HARRISON MWANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24085	\N	\N	\N	JOHNSON IRUNGU MUGURO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24086	\N	\N	\N	SUSAN RABERA ORWENYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24087	\N	\N	\N	LUCY WANJIKU KANUKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24088	\N	\N	\N	ELIZABETH WAIRIMU WANGUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24089	\N	\N	\N	PATRICK INDAI DANIEL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24090	\N	\N	\N	GERALD MAINGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24091	\N	\N	\N	FATUMA TATU OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24092	\N	\N	\N	WILLIAM KIMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24093	\N	\N	\N	MATHEW KIPKOSGEI LAGAT	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24094	\N	\N	\N	HADIJA OMARI FUMBWE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24101	\N	\N	\N	ABDUL MALIK BASHIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24102	\N	\N	\N	MOHAMED BAISHE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24103	\N	\N	\N	33ME804012373	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24104	\N	\N	\N	SAMUEL GITHAE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24105	\N	\N	\N	JUMA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24107	\N	\N	\N	HABIBA  MOHAMMAD AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24108	\N	\N	\N	Dorothy Kajuju Kamunde	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24109	\N	\N	\N	Kevin Yongo	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24110	\N	\N	\N	Ann Free	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24111	\N	\N	\N	ASHA SWALEH AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24112	\N	\N	\N	RAHIMA SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24113	\N	\N	\N	ABDULRASUI HUSSAIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24116	\N	\N	\N	KEVIN MOBISA NTABO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24117	\N	\N	\N	JOEL TIMOTHY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24118	\N	\N	\N	REBECCA OMWOMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24119	\N	\N	\N	ELIZABETH MUTHONI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24120	\N	\N	\N	ROBERT MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24122	\N	\N	\N	ABDILLAH YUSUF ALIY	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24123	\N	\N	\N	ABDULFATAH YASIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24124	\N	\N	\N	ERICK ERICK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24125	\N	\N	\N	MOHAMMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24126	\N	\N	\N	ABDI MOHAMMED BASHIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24127	\N	\N	\N	SAID HASSAN DAHIR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24128	\N	\N	\N	SHARIFA KHALIFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24129	\N	\N	\N	IAN NAWASON	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24130	\N	\N	\N	ELIZABETH WAIRIMU WAWERU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24131	\N	\N	\N	ANN NJERI KINYANJUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24132	\N	\N	\N	CAROLINE NDERITU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24133	\N	\N	\N	HAMISI JUMA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24134	\N	\N	\N	PETRONILLAH M	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24135	\N	\N	\N	GABRIEL MBARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24136	\N	\N	\N	ABDUL HAMID NASSOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24137	\N	\N	\N	MARTIN MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24138	\N	\N	\N	RUKIYA MOHAMMED SHEIKH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24139	\N	\N	\N	OMAR AHMED KHALIFA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24140	\N	\N	\N	HUSSEIN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24141	\N	\N	\N	LEYLA MOHAMMED SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24142	\N	\N	\N	KHALID ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24143	\N	\N	\N	MOHAMMED HAJI OMER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24144	\N	\N	\N	MOHAMMED FARAJ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24145	\N	\N	\N	FAHMI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24146	\N	\N	\N	SAID AHMAD ABOUD\t	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24147	\N	\N	\N	RAYMOND MAGHANGA MWAWUGHANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24148	\N	\N	\N	HASSAN HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24149	\N	\N	\N	NABIL SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24150	\N	\N	\N	THABIT AHMED MOHAMED MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24151	\N	\N	\N	HAFSWA ABDUL HAKIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24152	\N	\N	\N	HASSAN OMAR MUNGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24153	\N	\N	\N	FADYA HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24154	\N	\N	\N	Abdi Hassan	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24155	\N	\N	\N	 SALIM SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24156	\N	\N	\N	SALIM SAIDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24157	\N	\N	\N	OMAR AWADH SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24160	\N	\N	\N	SALIM ABDULAZIZ SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24161	\N	\N	\N	MAMA DENNIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24162	\N	\N	\N	FATUMA ABDALLA OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24163	\N	\N	\N	SEIF IDDI SEIF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24164	\N	\N	\N	ABEID SALIM ABEID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24165	\N	\N	\N	YUSUF SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24166	\N	\N	\N	HABIBA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24167	\N	\N	\N	NURU NUSURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24168	\N	\N	\N	MOHAMMAD OMAR ALI NASSAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24169	\N	\N	\N	GEORGE SURE GEORGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24170	\N	\N	\N	Rahim Mohammedali	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24171	\N	\N	\N	\tRAHIM MOHAMMEDALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24172	\N	\N	\N	AISHA HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24173	\N	\N	\N	SULEIMAN ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24174	\N	\N	\N	REHEMA IBRAHIM OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24175	\N	\N	\N	SAMMY NGUGI NDIGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24176	\N	\N	\N	FLORENCE ALIVITSA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24177	\N	\N	\N	AHMED KHALID SWALEH MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24178	\N	\N	\N	AHMED KHEIR ABDALLA AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24179	\N	\N	\N	FATUMA SWALEH MOHAMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24180	\N	\N	\N	KASIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24181	\N	\N	\N	ALMAS MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24182	\N	\N	\N	victor marionyo	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24183	\N	\N	\N	MOHAMMAED SAIF ABDULLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24184	\N	\N	\N	ABEID SHEBA ABEID S	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24185	\N	\N	\N	FATUMA ABDALLA ISLAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24186	\N	\N	\N	MOHAMED FEISAL SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24187	\N	\N	\N	MOHAMED BUNU MOHAMED ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24188	\N	\N	\N	SALIM ISLAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24189	\N	\N	\N	HUWAIDA SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24190	\N	\N	\N	MUNJURI EZRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24191	\N	\N	\N	DAVY KAMANZI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24192	\N	\N	\N	JAVAN DAVID DAVID MUNYOKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24193	\N	\N	\N	Gradus Lusi Warindu	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24194	\N	\N	\N	MASAAD MOHAMED SULEIMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24195	\N	\N	\N	SEIF SALIM SEIF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24196	\N	\N	\N	SHAMIM IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24197	\N	\N	\N	FAHD SAID MOHAMED AWADH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24621	\N	\N	\N	KENYA KAZI SERVICES LIMITED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24622	\N	\N	\N	Stanley Maina	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24623	\N	\N	\N	SAID FADHILUNA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24624	\N	\N	\N	SAID MUHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24625	\N	\N	\N	MARIAM ABUD AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24626	\N	\N	\N	SALIM SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24627	\N	\N	\N	Mohamed Ahmed	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24628	\N	\N	\N	HAMZA MOHAMED HAMZA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24629	\N	\N	\N	MARIAM MARIAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24630	\N	\N	\N	ABDIFATAH AHMED HASAAAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24631	\N	\N	\N	ABDI ADAN ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24632	\N	\N	\N	SAUM SALIM MUHAMMED KIMEA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24633	\N	\N	\N	BRAHIM JAFFAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24634	\N	\N	\N	HUSNA ABDULHALIM ABDUL RAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24635	\N	\N	\N	BAKARI MUHUNZI BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24636	\N	\N	\N	SWALE MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24637	\N	\N	\N	AMINA MOHAMED HAMISI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24638	\N	\N	\N	KHAMIS KHAMIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24639	\N	\N	\N	FARHIA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24640	\N	\N	\N	LONZE KESENWA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24641	\N	\N	\N	YASMIN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24642	\N	\N	\N	ASHA OMAR HAMADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24643	\N	\N	\N	MOHAMED SALIM MIHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24644	\N	\N	\N	HUSSEIN OMAR NASSER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24645	\N	\N	\N	AHMAD ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24646	\N	\N	\N	ASIA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24647	\N	\N	\N	MOHAMMED IDDY IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24648	\N	\N	\N	SALIM HAIFAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24649	\N	\N	\N	Grace Mugane	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24650	\N	\N	\N	Anita Na	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24651	\N	\N	\N	KHATIBU JUMA KHATIBU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24652	\N	\N	\N	CHARLES KARANJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24653	\N	\N	\N	ABDULHALIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24654	\N	\N	\N	STANELY MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24655	\N	\N	\N	JANET MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24656	\N	\N	\N	BASHIR MOHAMED OBO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24657	\N	\N	\N	MOHAMMED ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24658	\N	\N	\N	LUTFA HASSAN MOHAMOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24659	\N	\N	\N	MOHAMMAD OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24660	\N	\N	\N	HALIMA ABDALLAH 	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24661	\N	\N	\N	HALIMA ABDALLAH	\N	1	Not blacklisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24662	\N	\N	\N	ZAITUN KARAMA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24663	\N	\N	\N	AMINA ABDULLA HASSAN	\N	1	The name does not exist on ofac list.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24664	\N	\N	\N	Juliah Wanjiru	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24665	\N	\N	\N	JAPHETH OMONDI ODONYA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24666	\N	\N	\N	SULTAN ALII	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24667	\N	\N	\N	Mercy Miruka	\N	1	AML VERIFIOCATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24668	\N	\N	\N	dek mohamed	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24669	\N	\N	\N	ABDI SAID	\N	1	Not in OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24670	\N	\N	\N	NURU ISMAIL ABDALLA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24671	\N	\N	\N	SAIDA JUMA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24672	\N	\N	\N	REINHARD ODHIAMBO	\N	1	aml verification faliure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24673	\N	\N	\N	SAUDA AHMED MOHAMED	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24674	\N	\N	\N	MOHAMMAD SAID	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24675	\N	\N	\N	ALI ABUBAKAR ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24676	\N	\N	\N	SAIDA SWALEH SAID 	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24677	\N	\N	\N	Hassan Noor	\N	1	AML VERIFICATION FAUILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24678	\N	\N	\N	SAIDA SWALEH SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24679	\N	\N	\N	AZIZA SWALEH	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24680	\N	\N	\N	Luis Carlos Fernandez	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24681	\N	\N	\N	NAJAT ABDU IBRAHIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24682	\N	\N	\N	GRACE BORE	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24683	\N	\N	\N	ABDALLAH MOHAMMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24684	\N	\N	\N	HASSAN OMAR NASSER	\N	1	NAME NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24685	\N	\N	\N	ROSE 	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24686	\N	\N	\N	MOHAMED ABDURAHMAN OMAR	\N	1	NAME NOT ON OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24687	\N	\N	\N	SOFIA MALIAKA	\N	1	Not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24688	\N	\N	\N	KAMAU CHARLES CHARLES	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24689	\N	\N	\N	SOFI MOHAMED	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24690	\N	\N	\N	SHARIFA KHALIFA ADAM	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24691	\N	\N	\N	SHARIFA SHARIFF	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24692	\N	\N	\N	MOHAMED ABDUL KADIR ABDULLA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24693	\N	\N	\N	IBRAHIM SAMBULI	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24694	\N	\N	\N	MERASHID SALIM KUWANIA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24695	\N	\N	\N	SULEMAN ALI SALIM	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24696	\N	\N	\N	ABDUL HALIM ABDUALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24697	\N	\N	\N	AHMED MOHAMMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24698	\N	\N	\N	 MOHAMED ABBAS MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24699	\N	\N	\N	MOHAMMED MAHMOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24700	\N	\N	\N	OMAR MWAT SUMA TSUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24701	\N	\N	\N	OMAR AWADHI OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24702	\N	\N	\N	HASSAN YUSUF ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24703	\N	\N	\N	SALMA ABDULRAHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24704	\N	\N	\N	MOHAMED AHMED SHARIF	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24705	\N	\N	\N	ISLAM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24706	\N	\N	\N	ROMEO ROMEO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24707	\N	\N	\N	KHALID HASSAN JUMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24708	\N	\N	\N	IBRAHIM ALIOW	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24709	\N	\N	\N	HENRY WANDE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24710	\N	\N	\N	MARIAM SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24711	\N	\N	\N	HAWADOST MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24712	\N	\N	\N	RAHIA IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24713	\N	\N	\N	ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24714	\N	\N	\N	ABDIRAHMAN MAHAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24715	\N	\N	\N	ALI AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24716	\N	\N	\N	MEJUMAA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24717	\N	\N	\N	HUSSEIN SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24719	\N	\N	\N	HADIA ALI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24720	\N	\N	\N	IBRAHIM ISMAIL IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24721	\N	\N	\N	ABDALLAH ALI ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24722	\N	\N	\N	HUSSEIN SALIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24723	\N	\N	\N	IBRAHIM MOHAMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24724	\N	\N	\N	ABDIFATAH AHMED MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24725	\N	\N	\N	IBRAHIM JAFFAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24726	\N	\N	\N	MOMO MOHAMED SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24727	\N	\N	\N	MOHAMED ABDI TUNA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24728	\N	\N	\N	MOHAMED HASSAN MATAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24730	\N	\N	\N	SAIDA HASSAN MAHMUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24731	\N	\N	\N	E YOUNES	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24732	\N	\N	\N	ALI SAIDI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24733	\N	\N	\N	MUHAMAD AHMED SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24734	\N	\N	\N	SUSAN WANGARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24735	\N	\N	\N	SALEM OBAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24736	\N	\N	\N	RASHIDA KHALID	\N	1	The name does not exist on the OFAC list.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24737	\N	\N	\N	MARIA DEMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24738	\N	\N	\N	ALFRED LIBEYA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24739	\N	\N	\N	MAHMOUD SAID MOHAMED MIRAJ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24836	\N	\N	\N	ABDUL RAZAK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24740	\N	\N	\N	SULEIMAN HAMAD BACHARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24741	\N	\N	\N	NANCY WAIRIMU KARIA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24742	\N	\N	\N	NANCY  KARIA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24743	\N	\N	\N	AMINA MOHAMUD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24744	\N	\N	\N	HAIFA HUSSEIN ABDULLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24745	\N	\N	\N	AHMED ALI	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24746	\N	\N	\N	Abdalla Hassan	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24747	\N	\N	\N	PACHAKE HOLDINGS LIMITED	\N	1	NAME NOT ON  OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24748	\N	\N	\N	NAJMA ABDI MOHAMED	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24749	\N	\N	\N	ANNA MARIA STABRAWA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24750	\N	\N	\N	MOHAMMED JAFFAR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24751	\N	\N	\N	swaleh Abdalla	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24752	\N	\N	\N	SABURI SAID SABURI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24753	\N	\N	\N	ABDULWAHID ABUBAKAR	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24754	\N	\N	\N	ASHA WALI AHMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24755	\N	\N	\N	ABUBAKAR MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24756	\N	\N	\N	ABDULLAH ABDULLAH	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24757	\N	\N	\N	FRANCIS NDIRITU KIOKO	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24758	\N	\N	\N	MICHAEL ANDERSON	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24759	\N	\N	\N	BAKRANI OMARI BAKRANI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24760	\N	\N	\N	DZOMBO SALIM RASHID	\N	1	aml verification	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24761	\N	\N	\N	Anab Bule\t	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24762	\N	\N	\N	Anab Bule	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24763	\N	\N	\N	BAKARI MOHAMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24764	\N	\N	\N	Mazerah Mary	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24765	\N	\N	\N	FUAD MOHAMED SWALEH	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24766	\N	\N	\N	SUMEYA MUSA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24767	\N	\N	\N	PATRICK GACHIRI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24768	\N	\N	\N	IBRAHIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24769	\N	\N	\N	JAMAL MOHAMMED NASSER	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24770	\N	\N	\N	MOHAMED ABDULLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24771	\N	\N	\N	HASHINAH ABDALLAH	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24772	\N	\N	\N	ABUBAKAR HASSAN OMAR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24773	\N	\N	\N	NURU JAMAL MOHAMED	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24774	\N	\N	\N	ABUBAKAR ABDULHAKIM	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24775	\N	\N	\N	ABDUL LLAHI HUSSIEN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24776	\N	\N	\N	Samuel Maina	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24777	\N	\N	\N	GEORGE KARABA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24778	\N	\N	\N	SIHAM KHALID MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24779	\N	\N	\N	MARIAM KASERA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24780	\N	\N	\N	MWALIMU MOHAMED	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24781	\N	\N	\N	RUBY MOHAMED HUSSEIN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24782	\N	\N	\N	ALICE AMADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24783	\N	\N	\N	AHMED OMAR	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24784	\N	\N	\N	ADAN ABDILLAHI ADAN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24785	\N	\N	\N	TABU MUSTAFA YASSIN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24787	\N	\N	\N	SALIM SAID ABDULLAH AL KIYUMI	\N	1	Whitelisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24788	\N	\N	\N	SWAFIYA ABDUL NOOR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24789	\N	\N	\N	HEMED AWADH OMAR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24790	\N	\N	\N	RUBY MOHAMED HUSSEIN\t	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24791	\N	\N	\N	ABDALLA HASSAN	\N	1	Not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24792	\N	\N	\N	ALICE AMADI	\N	1	Not in OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24793	\N	\N	\N	ABDALLA ADAM SAAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24794	\N	\N	\N	SULEIMAN ATHMAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24795	\N	\N	\N	FADHWIL ABBAS MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24796	\N	\N	\N	ESTHER WANGARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24797	\N	\N	\N	ANDREW KARANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24798	\N	\N	\N	DANSON K NGANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24799	\N	\N	\N	ROBERT OMBWOGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24800	\N	\N	\N	ALI HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24801	\N	\N	\N	ILAORA MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24802	\N	\N	\N	AHMAD AMIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24803	\N	\N	\N	SAID OMAR SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24804	\N	\N	\N	BRAHIM MOHAMED AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24805	\N	\N	\N	ALI ISLAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24806	\N	\N	\N	ALBERT NJOROGE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24807	\N	\N	\N	Bashira Mohamed	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24808	\N	\N	\N	ABDULRAHMAN HAMID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24809	\N	\N	\N	HARRISON KAVILA AGINGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24810	\N	\N	\N	NAMEL ABDULLAH HUSSIEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24811	\N	\N	\N	DAUD ABDULLAHI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24812	\N	\N	\N	ALI SALIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24813	\N	\N	\N	ANNA WANJALA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24814	\N	\N	\N	FAITH RATIAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24815	\N	\N	\N	JOSHUA MAINGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24816	\N	\N	\N	NABIL ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24817	\N	\N	\N	MAUREEN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24818	\N	\N	\N	AWADH SWALEH AWADH MSAADA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24819	\N	\N	\N	HASSAN OMAR ATHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24820	\N	\N	\N	OMAR OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24821	\N	\N	\N	LATIFA ALI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24822	\N	\N	\N	FELIX GETIRIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24823	\N	\N	\N	SOFIA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24824	\N	\N	\N	ALI SAID ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24825	\N	\N	\N	ABUD ISSA ABUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24826	\N	\N	\N	MOHAMAD JUMA MOHAMAD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24827	\N	\N	\N	ALI ABDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24828	\N	\N	\N	ABUBAKAR AHMED BAJABER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24829	\N	\N	\N	NELLY GACHANJA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24830	\N	\N	\N	DAVID NDUNGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24832	\N	\N	\N	AHMED ABDIRAHMAN SHEIKH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24833	\N	\N	\N	\tSTANELY MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24834	\N	\N	\N	SULEIMAN MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24835	\N	\N	\N	FATIMA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24837	\N	\N	\N	EDMOND KAMINA EDMOND KAMINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24838	\N	\N	\N	MOHAMMED KASSIM AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24839	\N	\N	\N	SAMMY LOKORIO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24840	\N	\N	\N	ABDALLA ABDUL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24841	\N	\N	\N	ABDALLA ABDULRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24842	\N	\N	\N	MOHAMED SHARIFF	\N	1	aml verification failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24843	\N	\N	\N	RASHID ISMAIL	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24844	\N	\N	\N	FATMA MOHAMMED SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24845	\N	\N	\N	Hayat Ahmed	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24846	\N	\N	\N	ZAINA SALIM	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24847	\N	\N	\N	ABDUL IBRAHIM MUSA	\N	1	Not blacklisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24848	\N	\N	\N	AUSTIN NDEDA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24849	\N	\N	\N	Fadhil Mohamed Abdulkadir	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24850	\N	\N	\N	ISMAIL SALIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24851	\N	\N	\N	JAMAL ABDUL RAHMAN MAO	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24852	\N	\N	\N	AHMED ALI ISLAM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24853	\N	\N	\N	ABDU RAHIM HASSAN MOHADHARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24854	\N	\N	\N	ALWIY MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24855	\N	\N	\N	HUSSEIN OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24856	\N	\N	\N	SALIMA ABDULLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24857	\N	\N	\N	SHARIFFA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24858	\N	\N	\N	JOSE LUIS BERNAL OLIVO	\N	1	Whitelisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24859	\N	\N	\N	ROSALID NJOKI MUIGA ROSALID NJOKI MUIGA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24860	\N	\N	\N	ABUD SALIM AHMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24861	\N	\N	\N	Mariam Hassan	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24862	\N	\N	\N	LILIAN WAITHERA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24863	\N	\N	\N	ERASTUS IRUNGU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24864	\N	\N	\N	AHMED SAID	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24865	\N	\N	\N	AHLAM ISLAM	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24866	\N	\N	\N	JINA BASHIRA ABDALLA MOHAMED	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24867	\N	\N	\N	ALI ABUBAKAR ALII	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24868	\N	\N	\N	MOHAMED JAMAL ZAMZAM	\N	1	AML	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24869	\N	\N	\N	SELINE MANGARE	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24870	\N	\N	\N	Emmanuel Chumba	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24871	\N	\N	\N	ABDULLAH MOHAMMAD AMIN 	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24872	\N	\N	\N	ARISON MARIGA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24873	\N	\N	\N	ABDULLAH MOHAMMAD AMIN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24874	\N	\N	\N	SWALEH OMAR MOHAMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24875	\N	\N	\N	YASSIR SAID MOHAMMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24876	\N	\N	\N	HARUN	\N	1	reprocess	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24877	\N	\N	\N	HARUN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24878	\N	\N	\N	SULEIMAN MWIJAA SULEIMAN	\N	1	Name is not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24879	\N	\N	\N	Zahra Ali yusuf	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24880	\N	\N	\N	David Maina	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24881	\N	\N	\N	ELIZABETH WANJIKU NJOROGE	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24882	\N	\N	\N	AHMED RAJAB	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24883	\N	\N	\N	SALIM SWALEH SALIM	\N	1	the name does not appear on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24884	\N	\N	\N	JOAN SADIA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24885	\N	\N	\N	OMAR MBARAK	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24886	\N	\N	\N	IBRAHIM JUMA AMIR	\N	1	NAME NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24887	\N	\N	\N	FARIDA MOHAMMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24888	\N	\N	\N	GIDEON GIDEON NJOGU	\N	1	aml verification faliure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24889	\N	\N	\N	ATHMAN OMAR	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24890	\N	\N	\N	ALI ABDUL ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24891	\N	\N	\N	MALIHA MOHAMMAD ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24892	\N	\N	\N	 MOHAMMED MAHMOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24893	\N	\N	\N	MOHAMED ABBAS MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24894	\N	\N	\N	MALIHA MOHAMMAD ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24895	\N	\N	\N	pamela Dianga	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24896	\N	\N	\N	MASOUD HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24897	\N	\N	\N	FAYADH OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24898	\N	\N	\N	SULEIMAN ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24899	\N	\N	\N	ABDUL BARRI ABDUL RAHMAN HADI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24900	\N	\N	\N	SALIM ABDULRAHMAN SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24901	\N	\N	\N	AMINA HASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24902	\N	\N	\N	DICKEN ONYANGO OMONDI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24903	\N	\N	\N	JACKSON NAMBAKA AGALOMBA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24904	\N	\N	\N	ALI JUMA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24906	\N	\N	\N	SWALEH OMAR SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24907	\N	\N	\N	RAHMA ALI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24908	\N	\N	\N	HANNAH WAITHERA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24909	\N	\N	\N	HALIMA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24910	\N	\N	\N	MARIAMU OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24911	\N	\N	\N	EDWARD KARANJA EDW	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24912	\N	\N	\N	AHLAAM SALEH AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24913	\N	\N	\N	MOHAMED BAHERO HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24914	\N	\N	\N	JOSEPH KAYO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24915	\N	\N	\N	ABDUL KADIR MOHAMED ABDU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24916	\N	\N	\N	ABDUL AHMAD MANSOUR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24919	\N	\N	\N	OMAR HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24920	\N	\N	\N	AISHA ABDUL AZIZ	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24921	\N	\N	\N	ABDUL AZIZ KIMAITA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24923	\N	\N	\N	ABDULMOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24924	\N	\N	\N	MICHAEL NJOGU NYAMBURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24925	\N	\N	\N	ABDUL MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24926	\N	\N	\N	BAKARI MURAMBA BAKARI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24927	\N	\N	\N	MASOUD MASOUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24928	\N	\N	\N	MOHAMED ABDALLA KASSIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24929	\N	\N	\N	Hafsa Abdullahi	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24930	\N	\N	\N	SAID SALIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24931	\N	\N	\N	JUMA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24932	\N	\N	\N	ABDUL QADIR ABDALLA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24933	\N	\N	\N	SALIM GHARIBU SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24934	\N	\N	\N	ATHMAN OMAR ATHMAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24935	\N	\N	\N	Omar mahamud omar	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24936	\N	\N	\N	ZAID IBRAHIM NOOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24937	\N	\N	\N	MOHAMEDKADAR IBRAHIM IBRAHIM HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24938	\N	\N	\N	MAURINE SANTINO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24939	\N	\N	\N	DANIEL MAKORI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24940	\N	\N	\N	ABDALLA MOHAMED ABDALLA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24941	\N	\N	\N	ABDALLA MOHAMED ABDALLA JEFFA	\N	1	aml verification failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24942	\N	\N	\N	SHABAN MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24943	\N	\N	\N	NAIMA SALIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24944	\N	\N	\N	AHADI IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24945	\N	\N	\N	ALI BAKARI SAID	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24947	\N	\N	\N	SAUDA AHMED	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24948	\N	\N	\N	ABDULWAKIL AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24949	\N	\N	\N	AHMED ABDULLA KARAMA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24950	\N	\N	\N	JUMAA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24951	\N	\N	\N	ALI KHAMIS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24952	\N	\N	\N	JOHN MWAI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24953	\N	\N	\N	Sheikh Mohamed Amin	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24954	\N	\N	\N	garad abdi noor	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24955	\N	\N	\N	HUSSEIN ABDUL GAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24956	\N	\N	\N	SAID HASSAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24957	\N	\N	\N	Jesinta Njeri Mbothu	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24958	\N	\N	\N	NGOA NDORO NGOA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24959	\N	\N	\N	JUDITH KERUBO NYAMARI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24960	\N	\N	\N	JERUSHA WANJIKU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24961	\N	\N	\N	ABDULLAHI HUSSIEN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24962	\N	\N	\N	SALIMA ABDALLA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24963	\N	\N	\N	MOHAMMED SWALEH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24965	\N	\N	\N	Sauda Ali	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24966	\N	\N	\N	Ahmed Ismail	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24967	\N	\N	\N	MOHAMMAD MZEE MOHAMED	\N	1	The name does not exist on OFAC. 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24968	\N	\N	\N	JOYCE WANJIRU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24969	\N	\N	\N	RUSTOM KHAN NASIR KHAN SAHIBKHAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24970	\N	\N	\N	ABUBAKAR HASSAN	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24971	\N	\N	\N	SHADYA SAID	\N	1	Name not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24972	\N	\N	\N	MBARAK OMAR MBARAK	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24973	\N	\N	\N	AHMED HASSAN MWARORA	\N	1	Name does not appear in OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24974	\N	\N	\N	JANE CHEGE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24975	\N	\N	\N	ASHA SHABAN	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24976	\N	\N	\N	Nuru Salim	\N	1	Name not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24977	\N	\N	\N	amir Malik	\N	1	Name not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24978	\N	\N	\N	FAIZ AHMED ABDULRHMAN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24979	\N	\N	\N	ZAITUNI MOHAMMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24980	\N	\N	\N	AMINA MUHAMAD IDRIS	\N	1	The name does not exist on Ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24981	\N	\N	\N	MOHAMED SAID MWAPERU	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24982	\N	\N	\N	Omuse David	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24983	\N	\N	\N	NANCY KARIA	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24984	\N	\N	\N	WANAMATAIFA INVESTMENT COMPANY LTD	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24985	\N	\N	\N	MURAD EBRAHIM MURAD	\N	1	The name does not exist on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24986	\N	\N	\N	SARAH MWENDE LUKOYE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24987	\N	\N	\N	SAUD SAUDA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24988	\N	\N	\N	Armstrong Ongera	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24989	\N	\N	\N	ABDULREHMAN SWALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24990	\N	\N	\N	GEORGE WAWERU MBUTHIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24991	\N	\N	\N	KEVIN KIMANI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24992	\N	\N	\N	STEPHEN LIJODI KAGASI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24993	\N	\N	\N	PETER MUIRURI NGIGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24994	\N	\N	\N	RECHO CHEBET	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24995	\N	\N	\N	JULIE ANNE WANJIRU NDERI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24996	\N	\N	\N	FRED OGEGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24997	\N	\N	\N	mohamed Abubakar	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24998	\N	\N	\N	ALI ADAM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	24999	\N	\N	\N	Framor Victor	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25000	\N	\N	\N	ABEID SWALEH ABEID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25062	\N	\N	\N	HALIMA ABDULLAHI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25063	\N	\N	\N	BAHASSAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25064	\N	\N	\N	ABDI AHMED SHEIKH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25065	\N	\N	\N	leona Omariba	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25066	\N	\N	\N	ZAID NOOR IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25067	\N	\N	\N	HUSSEIN HASSAN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25068	\N	\N	\N	MOHAMEDKADAR IBRAHIM HASSAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25069	\N	\N	\N	MAUREEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25070	\N	\N	\N	HASSAN IBRAHIM ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25071	\N	\N	\N	ABDUL RAHMAN AHMED BABU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25072	\N	\N	\N	ABDUL RAHMANI SHEE MWINYI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25073	\N	\N	\N	ABDI MOHAMED ABI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25074	\N	\N	\N	HUSSEIN OMAR BOCHA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25075	\N	\N	\N	AZIZA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25076	\N	\N	\N	HUDAA ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25077	\N	\N	\N	VIRGINIA VIRGINIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25078	\N	\N	\N	NANCY MUGURE NANCY MUGURE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25079	\N	\N	\N	OMER ABDUL RAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25080	\N	\N	\N	MUHAMMAD JAFFAR OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25081	\N	\N	\N	MWALIMU HUSSEIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25082	\N	\N	\N	KHALIF HASSAN ADAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25083	\N	\N	\N	ALI SAIDI ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25084	\N	\N	\N	Stima Sacco Society Limited	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25085	\N	\N	\N	LEAH KIRIRA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25086	\N	\N	\N	WANZA MUTUKU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25087	\N	\N	\N	ELLAM MOSES MUNIAFU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25088	\N	\N	\N	ELLAM MOSES MOSES MUNIAFU	\N	1	Verified	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25089	\N	\N	\N	ABDUL RAHMAN KIMANI KASSIM	\N	1	AML VERIFIUCATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25090	\N	\N	\N	ANSWAR HAMAD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25091	\N	\N	\N	LAUREEN KITHEKA	\N	1	The name does not on exist on Ofac List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25092	\N	\N	\N	RISCO NJOROGE	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25093	\N	\N	\N	GEORGE VALENTINE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25094	\N	\N	\N	ANITA ENANE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25095	\N	\N	\N	ARTHUR NJOROGE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25096	\N	\N	\N	ISSA AHMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25097	\N	\N	\N	ALPHONCE MVOI NJOGHOLO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25098	\N	\N	\N	SARAH MAKORI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25099	\N	\N	\N	SALIM TWALIB ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25100	\N	\N	\N	FARHIA ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25101	\N	\N	\N	ROBERT  	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25102	\N	\N	\N	HALIMA ALI MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25103	\N	\N	\N	SULEIMAN MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25104	\N	\N	\N	MARJAN OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25132	\N	\N	\N	MUHAMADI SHEIKH ISSA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25138	\N	\N	\N	DUNCAN KARIUKI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25145	\N	\N	\N	OMAR RASHID SAID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25147	\N	\N	\N	MARGARET NDUNGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25153	\N	\N	\N	PAULINE MORAA KINYANJUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25164	\N	\N	\N	DENIS MUHURI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25165	\N	\N	\N	ESTHER MACHARIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25166	\N	\N	\N	RAHMA SALIM MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25167	\N	\N	\N	HAMIDA IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25168	\N	\N	\N	CATHERINE MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25169	\N	\N	\N	LUCY MBUGUA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25170	\N	\N	\N	JUMA YUSUF JUMA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25171	\N	\N	\N	MWAKA MOHAMMED	\N	1	not in the list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25172	\N	\N	\N	HASSAN TALLAH	\N	1	not in the list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25173	\N	\N	\N	PATRICK MATERI MATERI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25174	\N	\N	\N	ALI MOHAMMED ABDALLAH	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25176	\N	\N	\N	ANNA WANGARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25177	\N	\N	\N	MAULIDI ALI BAKARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25178	\N	\N	\N	MOHAMED IBRAHIM JAFFER	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25179	\N	\N	\N	Mohamed Muhumed	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25181	\N	\N	\N	Ibrahim Noor	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25182	\N	\N	\N	SELINE MANGARE 	\N	1	AML Verifiation failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25183	\N	\N	\N	FAUZ MOHHAMED	\N	1	AML Verification Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25184	\N	\N	\N	Bashir mohamed	\N	1	AML verification	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25185	\N	\N	\N	Mary Nderi	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25186	\N	\N	\N	Nana Aboud	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25187	\N	\N	\N	Abdul Swamad Shee	\N	1	Not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25188	\N	\N	\N	ABDALLAH MOHAMED ALI	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25189	\N	\N	\N	MWANAISHA SWALEH AHMED	\N	1	aml	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25190	\N	\N	\N	Dek Mohamed	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25191	\N	\N	\N	HALIMA AHMED ALI	\N	1	Name is not on OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25192	\N	\N	\N	NASRA SALIM	\N	1	process	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25193	\N	\N	\N	KHADIJA MOHAMED ABDI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25194	\N	\N	\N	Mahamed Ibrahim	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25195	\N	\N	\N	BITI SAID	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25196	\N	\N	\N	MOHAMED HAMID	\N	1	The name does not exist on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25197	\N	\N	\N	MASSAD ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25198	\N	\N	\N	ZAMZAM ABDALLA	\N	1	AML	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25199	\N	\N	\N	SALIM SALIM	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25200	\N	\N	\N	ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25201	\N	\N	\N	FAIZA AHMED ABDULRAHMAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25202	\N	\N	\N	JAMAL MOHAMED	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25203	\N	\N	\N	AHMED ALI SALIM	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25204	\N	\N	\N	BADI MWALIMU MOHAMMED	\N	1	NAME NOT FOUND ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25205	\N	\N	\N	MOHAMED FADHI LUNA	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25206	\N	\N	\N	and Blair Dyer and Blair Investment Bank	\N	1	AML VERIFICATION FAILUR	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25207	\N	\N	\N	TIMOTHY MAINA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25208	\N	\N	\N	MOHAMED HUSSEIN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25209	\N	\N	\N	OMAR SALIM OMAR	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25210	\N	\N	\N	SHEE ABDUL RAHMAN RUPHUTSU	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25211	\N	\N	\N	ABDALLA RAMADNI	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25212	\N	\N	\N	HASSAN MOHAMED PAPALA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25213	\N	\N	\N	MICHAEL ANDALO	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25214	\N	\N	\N	ABZED ABDUL MOHAMMED	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25215	\N	\N	\N	AISHA ABU	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25216	\N	\N	\N	NWANAISHA ABDUL RAHMAN	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25217	\N	\N	\N	MASBAI MOHAMED	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25218	\N	\N	\N	MOHAMED ABDULRAHMAN ABDALLA HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25219	\N	\N	\N	LETOYA TOYA\t	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25220	\N	\N	\N	MOHAMED ATHUMANI HAMZA	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25221	\N	\N	\N	ABDULAHI HUSSAIN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25222	\N	\N	\N	FAIZA FUAD MOHAMED	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25223	\N	\N	\N	IBRAHIM MOHAMUD IBRAHIM	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25224	\N	\N	\N	ABDUL AZIZ SALIM	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25225	\N	\N	\N	SULEIMAN SWALEH MUHAMMAD\t	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25226	\N	\N	\N	MARY MARI KIONGO	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25227	\N	\N	\N	FREDRICK FREDRICK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25228	\N	\N	\N	PATHWAY TO LIFE MINISTRIE PATHWAY TO LIFE MINISTRIE	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25229	\N	\N	\N	AMIN ABDULLAHI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25230	\N	\N	\N	ELVIS WANGUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25231	\N	\N	\N	ASHRAF HUSSEIN	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25232	\N	\N	\N	MOHAMED ABULLA MAALIM	\N	1	Name not in OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25233	\N	\N	\N	SADA SAID MWADINDO	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25234	\N	\N	\N	ABDULLAHI HUSSEIN MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25235	\N	\N	\N	CHENGO KAZUNGU CHENGO	\N	1	not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25236	\N	\N	\N	MUNIRA OMAR IBRAHIM	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25237	\N	\N	\N	OMAR ABAA\t	\N	1	not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25238	\N	\N	\N	OMAR ABAA	\N	1	not on ofac lsit	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25239	\N	\N	\N	JUMA SAID JUMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25240	\N	\N	\N	MOHAMED SULEIMAN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25241	\N	\N	\N	IBRAHIM KHAMIS IBRAHIM	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25242	\N	\N	\N	DAVID DAVID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25243	\N	\N	\N	MWIDANI HASSAN MOHAMED	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25244	\N	\N	\N	GEORGE JUMA\t	\N	1	Not on the OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25245	\N	\N	\N	ELIZABETH MEDZA GAMIMBA	\N	1	Not on OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25246	\N	\N	\N	OMAR OMAR BAKARI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25247	\N	\N	\N	GEORGE JUMA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25248	\N	\N	\N	MASUDI ALI	\N	1	Name flagged due to the common name ALI however the name sanction ed on OFAC is not the same.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25249	\N	\N	\N	HABIBA ADAM AHMED	\N	1	Name flagged due to name AHMED however his not the same as the one sanctioned on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25250	\N	\N	\N	MARTIN LUTHER	\N	1	flagged due to the Name Martin same as the Brigadier General of Venuezuela however no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25251	\N	\N	\N	AMINA ABDALLA MOHAMED	\N	1	Name flagged due to the common name AMINA ABDALLA however his not associated with the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25252	\N	\N	\N	BAKARI ALI	\N	1	Full names Ali Bakari Mwayambi, DOB 12/04/1992, Kenya hence has no relation with sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25253	\N	\N	\N	ABDUL LATIF SULEMAN SALEH	\N	1	Flagged due to name Abdul Latif however we received his ID & verified his not the same as the flagge	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25254	\N	\N	\N	YUSUF ALI YUSUF	\N	1	Name flagged due to the common name Yusuf however his not associated to the sanctioned person	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25255	\N	\N	\N	ABDUL LATIF SULEMAN  SALEH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25256	\N	\N	\N	HAILIE IBRAHIM SAID	\N	1	Name flagged due to the common name Haile however the sanctioned is a PEP in syria hence no relation	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25257	\N	\N	\N	MOHAMMED RASHID	\N	1	Beneficiary Kenyan ID provided and verified that he has no relation to the sanctioned Individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25258	\N	\N	\N	HALIMA ALI	\N	1	Name flagged due to the common name AlI however she has no association with the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25259	\N	\N	\N	ABDULLAH SAID	\N	1	Name flagged due to the common name ABDULLAH however he has no association to the sanctioned person.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25260	\N	\N	\N	MAHMOUD SALIM	\N	1	Individual flagged on OFAC is not the same as MAHMOUD SALIM	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25261	\N	\N	\N	BENARD OGUTU	\N	1	Name flagged due to Ogutu same as the PEP of Zimbabwe however they have no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25262	\N	\N	\N	JUMA MWINYI JUMA	\N	1	Flagged due to the common name JUMA however the individual flagged on OFAC s a PEP hence no relation	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25263	\N	\N	\N	SAID ABDU ANWAR	\N	1	Flagged due to the common name SAID however he has no relation to the santioned Individual on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25264	\N	\N	\N	MESALIMU SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25352	\N	\N	\N	SALIM ABUU YUSUF	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25265	\N	\N	\N	MURAD ABDULKARIM	\N	1	The sanctioned individual on OFAC is currently incarcerated hence why the client has no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25266	\N	\N	\N	HUSSEIN NASSIR HUSSEIN	\N	1	False match on OFAC name does not matche the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25267	\N	\N	\N	SAID ABDU  ANWAR~KEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25268	\N	\N	\N	SAID ABDU  ANWAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25269	\N	\N	\N	ABDULRAHMAN MOHAMED HATIMY	\N	1	False match on OFAC due to the common name ABDULRAHMAN hence has no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25270	\N	\N	\N	TABU MUSTAFA YASSIN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25271	\N	\N	\N	SALMA MOHAMED SAID	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25272	\N	\N	\N	RASHIDA HALID 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25273	\N	\N	\N	ALI MUHAMMED OMAR	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25274	\N	\N	\N	ABDUL KADER MOHAMED AWADH SALIM	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25275	\N	\N	\N	AWADH SAID AWADH	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25276	\N	\N	\N	noor Abdullah\t	\N	1	NOT FOUND ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25277	\N	\N	\N	Josephat Maina	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25278	\N	\N	\N	Ida Angela	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25279	\N	\N	\N	MAURINE NELIMA	\N	1	Name not in OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25280	\N	\N	\N	ADAN ABDILLAHI ADAN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25281	\N	\N	\N	ABDULRAHMAN AHMED BABU	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25282	\N	\N	\N	HASSAN ABDALLA MAYANI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25283	\N	\N	\N	HASSAN HAMISI SALIM SHEE	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25284	\N	\N	\N	EDWIN MUTAI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25285	\N	\N	\N	MOHAMED ALI MOHAMED FANI	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25286	\N	\N	\N	HASSAN MOHAMMED HASSAN\t	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25287	\N	\N	\N	ABDUL AZIZ HABIB MUSA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25288	\N	\N	\N	HASSAN MOHAMMED HASSAN	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25289	\N	\N	\N	ABDUL FATAH JAMAL KASSIM	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25290	\N	\N	\N	ALI MOHAMMED	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25291	\N	\N	\N	FUAD FEISAL ABDULLAH MUHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25292	\N	\N	\N	ABDULAZIZ SAID ALI	\N	1	aml verification failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25293	\N	\N	\N	ABDALLA FADHIL	\N	1	NOT FOUND ON THE OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25294	\N	\N	\N	NGUNGI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25295	\N	\N	\N	MOHAMED ABUD MITTWAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25296	\N	\N	\N	ABDUL JABBAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25297	\N	\N	\N	SALIM ABDUL SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25298	\N	\N	\N	HUDAA ALI SALIM	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25299	\N	\N	\N	AHMED FARID AHMED JIN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25300	\N	\N	\N	FARAH MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25301	\N	\N	\N	AHMED ABDULRAHMAN ABDALLA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25302	\N	\N	\N	Simon Simon	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25303	\N	\N	\N	SAIDI ABDALLA SAIDI	\N	1	Not on the Ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25304	\N	\N	\N	TABITHA NYAMBURA NYAMBURA KIHARA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25305	\N	\N	\N	KEVIN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25306	\N	\N	\N	STANLEY 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25307	\N	\N	\N	IKHTIYAAR YOUSEF ABDULL RAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25308	\N	\N	\N	SUAAD MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25309	\N	\N	\N	Abdi Abdi	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25310	\N	\N	\N	Mama Ali	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25311	\N	\N	\N	mohamud sadiq	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25312	\N	\N	\N	Ahmed Aden Ibrahim	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25313	\N	\N	\N	Ali noor Ahmed	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25314	\N	\N	\N	PETER IRUNGU	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25315	\N	\N	\N	SULEYMAN HAMDA ALI	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25316	\N	\N	\N	ELVIS BANDO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25317	\N	\N	\N	MUSLIMA ABDALLAH	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25318	\N	\N	\N	HAMIDA ABDULREHMAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25319	\N	\N	\N	TIMOTHY MAINA TIMOTHY MAINA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25320	\N	\N	\N	RUKIA MOHAMED SWALEH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25321	\N	\N	\N	ALI KHAMISI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25322	\N	\N	\N	ZUHURA JAMAL ABDALLA	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25323	\N	\N	\N	MOHAMED SAID	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25324	\N	\N	\N	HADIYA MOHAMMED 	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25325	\N	\N	\N	KHAMIS SALIM KHAMIS	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25326	\N	\N	\N	SWALESH AHMED MOHD	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25327	\N	\N	\N	YUNUS MUHAMMED	\N	1	NOT ON OFAC 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25328	\N	\N	\N	YUNUS MUHAMMED 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25329	\N	\N	\N	ANWAR AHMED HASSAN	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25330	\N	\N	\N	ASMA ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25331	\N	\N	\N	AUNAKA ABUBAKAR	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25332	\N	\N	\N	ABDUL MAJID SHAFFI	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25333	\N	\N	\N	HASSAN HALFAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25334	\N	\N	\N	SALIM ISMAIL	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25335	\N	\N	\N	MOHAMED HILAL SAID AL BATRANI	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25336	\N	\N	\N	SWALEH MOHAMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25337	\N	\N	\N	IBRAHIM MOHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25338	\N	\N	\N	OMAR SWALEH MOHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25339	\N	\N	\N	SALIM MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25340	\N	\N	\N	MOHAMMAD ABDUL RASOOL	\N	1	not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25341	\N	\N	\N	NURU ALI	\N	1	not in the OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25342	\N	\N	\N	SALIM MOHAMMED ALI	\N	1	not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25343	\N	\N	\N	ABDULLA MOHAMED HAMID	\N	1	not on the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25344	\N	\N	\N	ALI HAMAD ABDULLA A	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25345	\N	\N	\N	ALI HAMAD ABDULLA A 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25347	\N	\N	\N	ABUL SAID CHIBAYA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25348	\N	\N	\N	IBRAHIM KAMAW	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25349	\N	\N	\N	ESHA MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25350	\N	\N	\N	ABDALLAH MOHAMMAD ABDALLAH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25351	\N	\N	\N	HABIBA MOHAMMAD AHMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25353	\N	\N	\N	MWANAMGENI SAID	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25354	\N	\N	\N	IBRAHIM KALIMBO	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25355	\N	\N	\N	JOHN KAMAU MUTURI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25356	\N	\N	\N	SULEMAN MUHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25357	\N	\N	\N	BALO BALO	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25358	\N	\N	\N	FANAKA REAL ESTATE LTD	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25359	\N	\N	\N	ALIA AHMED OMAR	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25360	\N	\N	\N	FATUMA MOHAMMED ABDI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25361	\N	\N	\N	HASSAN MOHAMMED MUUMIN	\N	1	Whitelisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25362	\N	\N	\N	ZAMZAM ABDUL LATIF ALI	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25363	\N	\N	\N	HAMDAN KHALILI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25368	\N	\N	\N	HASSAN HAMISI SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25369	\N	\N	\N	Ahmed khalif	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25370	\N	\N	\N	Edwin Mutai	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25371	\N	\N	\N	MARGARET MGHAZO MSHAMBA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25372	\N	\N	\N	DOR MOHAMED MOHAMED	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25373	\N	\N	\N	Victor Njoroge	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25374	\N	\N	\N	FABIANAS	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25375	\N	\N	\N	NGUNGI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25376	\N	\N	\N	SALIMA MOHAMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25377	\N	\N	\N	ALI	\N	1	Name not in the Ofac List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25378	\N	\N	\N	FATIMA MOHAMED SHAIKH	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25379	\N	\N	\N	Mahad Abdi	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25380	\N	\N	\N	MOHAMED ALI ABDILLE	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25381	\N	\N	\N	SALIM HAMADI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25385	\N	\N	\N	NANCY MORAA	\N	1	Txn cancelled but the client was sent funds	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25386	\N	\N	\N	HADIYA MOHAMMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25387	\N	\N	\N	BONFACE KARANJA KARANJA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25388	\N	\N	\N	AHMED AMIR AHMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25389	\N	\N	\N	LAWRENCE M MBAABU	\N	1	Double paid client through CBA Bank	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25390	\N	\N	\N	AHMED ABDULLAH	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25391	\N	\N	\N	MARTINE MWAURA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25392	\N	\N	\N	HAFSA OMAR	\N	1	not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25393	\N	\N	\N	JAMILA ALI	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25394	\N	\N	\N	FAIZA AHMED ABDULRHMAN	\N	1	Not in OFAC List 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25395	\N	\N	\N	SALMA HASSAN	\N	1	not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25396	\N	\N	\N	AZIZA MOHAMED	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25397	\N	\N	\N	TERESIA MAKORI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25398	\N	\N	\N	SULEIMAN MAMBO MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25399	\N	\N	\N	SHAMIM MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25400	\N	\N	\N	JAMILA NASIR KHAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25401	\N	\N	\N	ALI DAHIR	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25402	\N	\N	\N	TALHA MOHAMMED	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25403	\N	\N	\N	HADIJA MOHAMED IBRAHIM	\N	1	not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25404	\N	\N	\N	AMRI SULEIMAN AMRI	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25405	\N	\N	\N	ANDREW MAINA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25406	\N	\N	\N	ALICE ACHIENG	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25407	\N	\N	\N	HAMSI MOHAMMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25408	\N	\N	\N	RAHSID SALIM SAWA	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25409	\N	\N	\N	ALI ABDALLAH MOHAMMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25410	\N	\N	\N	MPESA CASA MPESA CASA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25411	\N	\N	\N	MOHAMED ISSACK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25412	\N	\N	\N	ABDALLAH ABDUL KADIR SALEH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25413	\N	\N	\N	MWAMADI SWALEH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25414	\N	\N	\N	KASSIM ABUD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25415	\N	\N	\N	MAZERAH THOMAS THOMAS	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25416	\N	\N	\N	ANWAR ABDULLA SAID	\N	1	Not  on te OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25417	\N	\N	\N	ALI HAMADI JUMA	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25418	\N	\N	\N	ZURA ABDUL AZIZ	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25419	\N	\N	\N	ANDREW NJOROGE	\N	1	not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25420	\N	\N	\N	RAMADHAN ABDALLA MACHARIA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25421	\N	\N	\N	LUQMAN ANWAR SAID	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25422	\N	\N	\N	HAFSWA ABOALLAH	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25423	\N	\N	\N	JAFFAR ALI MOHAMED	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25424	\N	\N	\N	MOHAMED MASILA	\N	1	not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25425	\N	\N	\N	HASSAN MOHAMMED	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25426	\N	\N	\N	ABDALLAH HASSAN KHAMISI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25427	\N	\N	\N	MOHAMMAD HAMADI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25428	\N	\N	\N	ALICE ACHIENG OCHIENG	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25429	\N	\N	\N	SAID ABDALLA MOHAMMED	\N	1	Not on the OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25430	\N	\N	\N	MAULID ALI YUSUF	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25431	\N	\N	\N	RIYADH MOHAMED SAID	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25432	\N	\N	\N	ABDUL RAHMAN\t	\N	1	not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25433	\N	\N	\N	ABDUL RAHMAN	\N	1	not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25434	\N	\N	\N	ISSA MOHAMED KASSIM DAIMUS	\N	1	not on OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25435	\N	\N	\N	MUHAMMED SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25436	\N	\N	\N	OMARI OMARI MWAKAMA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25437	\N	\N	\N	SARA ACHIENG OCHIENG	\N	1	Does not appear on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25438	\N	\N	\N	AHMED ABDULLAH RAMADHAN	\N	1	not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25439	\N	\N	\N	Esther Abuga	\N	1	Client was double paid bank deposit	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25440	\N	\N	\N	FIRDAUS ABDUL HUSSEIN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25441	\N	\N	\N	SALIMU AZIZI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25443	\N	\N	\N	ALI MOHAMED SALIM	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25444	\N	\N	\N	RASHIDA HALID	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25445	\N	\N	\N	ABDULLAH ABDUL	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25446	\N	\N	\N	MOHAMED BAKARI MOHAMED	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25447	\N	\N	\N	SABINA MAINA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25451	\N	\N	\N	Amiso amigoa	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25452	\N	\N	\N	ZULFA ABDULKARIM ABUBAKAR MOHAMED	\N	1	The named does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25453	\N	\N	\N	halima hassan	\N	1	Name is not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25454	\N	\N	\N	safia mohammed farah	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25455	\N	\N	\N	Noor Mohamedvv	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25456	\N	\N	\N	MOHAMED SAIDI HAMISI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25457	\N	\N	\N	MAHSAN OMAR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25458	\N	\N	\N	SULEIMAN MAZULO MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25459	\N	\N	\N	NASIM ABUBAKAR MOHAMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25460	\N	\N	\N	SHEIKHA MOHAMMAD	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25461	\N	\N	\N	MWANAMKASI OMARI OMARI MATABISHI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25464	\N	\N	\N	ELMI ALI	\N	1	not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25465	\N	\N	\N	OSMAN ALI	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25466	\N	\N	\N	MASOUD HASSAN SALIM	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25467	\N	\N	\N	ABDUL AZIZ ISLAM	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25468	\N	\N	\N	MARILYN MARILYN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25469	\N	\N	\N	LILAN OCHIENG	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25470	\N	\N	\N	SULEIMAN ALI SULEIMAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25471	\N	\N	\N	ALI ALMASI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25472	\N	\N	\N	SWALEH AHMED YUSUF	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25473	\N	\N	\N	MOHAMMED O SULEIMAN	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25474	\N	\N	\N	ABU BACKER	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25475	\N	\N	\N	LETOYA TOYA	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25476	\N	\N	\N	DORMOHAMED MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25477	\N	\N	\N	AHMED KHALFAN AL KHARUSI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25478	\N	\N	\N	MOHAMED ABDI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25479	\N	\N	\N	KADIJA MOHAMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25480	\N	\N	\N	MOHAMMED AHMED MOHAMMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25481	\N	\N	\N	SUDI SALIM AMAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25482	\N	\N	\N	DINA SIMONI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25484	\N	\N	\N	SHEKHA MOHAMMED SULEIMAN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25485	\N	\N	\N	HASSAN HALFAN\t	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25486	\N	\N	\N	SALIM ISMAIL\t	\N	1	not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25487	\N	\N	\N	OMAR MOHAMED FADHIL	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25488	\N	\N	\N	MUHAMMED HUSSEIN OMONDI	\N	1	Not found on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25489	\N	\N	\N	NAHYA MOHAMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25490	\N	\N	\N	MUNIRA HUSSEIN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25491	\N	\N	\N	ALI SALIM	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25492	\N	\N	\N	AHMED ABDULLAH RAMADHANI	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25493	\N	\N	\N	SAID ABDALLA SAID	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25494	\N	\N	\N	ABDUL RAHMAN OBO AMIN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25495	\N	\N	\N	MOHAMED HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25496	\N	\N	\N	ABDALLA SAID ABDALLA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25497	\N	\N	\N	FAIZA OMAR ABDUL RAHMAN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25498	\N	\N	\N	AHMED ABDILMUIN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25499	\N	\N	\N	ABDULRAHMAN ABDULLA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25500	\N	\N	\N	HASSAN KHATIB	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25501	\N	\N	\N	GEORGE WACHIRA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25502	\N	\N	\N	SWALHA MOHD ABDUL RAHMAN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25503	\N	\N	\N	USAMA IDI USAMA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25504	\N	\N	\N	Explorers Camp Mara Explorers Camp Enterprises Ltd	\N	1	Name not in OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25505	\N	\N	\N	BADI FUNDI BADI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25506	\N	\N	\N	OMAR ALI OMAR	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25507	\N	\N	\N	JONATHAN JOHN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25508	\N	\N	\N	KHALIDA MOHAMED HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25509	\N	\N	\N	MWALIMU AHMED	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25510	\N	\N	\N	NABILA MOHAMAD RASHID	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25511	\N	\N	\N	SULEIMAN MOHAMMED MZEE	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25512	\N	\N	\N	MURAD OMAR ABDUL RAHMAN	\N	1	not on OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25513	\N	\N	\N	BERINA JUMWA KARISA JUMWA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25514	\N	\N	\N	SALIM NASSIR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25515	\N	\N	\N	ABDALLAH ABDULRAHMAN ABDALLA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25516	\N	\N	\N	IBRAHIM BABA CALI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25517	\N	\N	\N	SAIDA MUHAMMAD ALI	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25518	\N	\N	\N	HUSSEIN NASSIR HUSSEN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25519	\N	\N	\N	AHMED SWALEH ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25520	\N	\N	\N	ABDULLAH HASSAN MAKAME	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25521	\N	\N	\N	YASIN ABDULQADIR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25522	\N	\N	\N	SALMA MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25523	\N	\N	\N	ALI JAFFERI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25524	\N	\N	\N	FRED JOHN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25525	\N	\N	\N	ABDULNASSIR ABDALLA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25526	\N	\N	\N	RASHIDA ISSA RASHID MWAJITA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25527	\N	\N	\N	SWABIR SAID MOHAMED	\N	1	Not on Ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25528	\N	\N	\N	JAMIL JAMAL	\N	1	not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25529	\N	\N	\N	ABDALLA SWALEH	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25530	\N	\N	\N	MASAD MOHAMED SULAIMAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25531	\N	\N	\N	AHMED ABDUL SHEIK	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25534	\N	\N	\N	Mohamed Abdi hilowle	\N	1	Name not found on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25535	\N	\N	\N	AMINA MOHAMMAD FAMAU	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25536	\N	\N	\N	noor Abdullah	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25537	\N	\N	\N	MOHAMMED MAHIR	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25538	\N	\N	\N	ADAN ABDILLAHI ADAN	\N	1	Whitelisted	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25539	\N	\N	\N	IDRISS MOHAMED HASSAN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25540	\N	\N	\N	SANDE JOEL	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25541	\N	\N	\N	BHERNARD MORIANGO	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25542	\N	\N	\N	DALILA JUMA SALIM	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25543	\N	\N	\N	JUMA MOHAMED	\N	1	The name does not exist on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25544	\N	\N	\N	SALIM ALI RAMADHAN	\N	1	The name does not exist on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25545	\N	\N	\N	Mohamed farah	\N	1	The name does not appear on the Ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25546	\N	\N	\N	MARYAM ANWAR SAID	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25547	\N	\N	\N	Nasra mohamed Mohamed	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25548	\N	\N	\N	Hamza mohamed Abdullahi	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25549	\N	\N	\N	ahmed mohamed	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25550	\N	\N	\N	MOHAMMED NASSIR	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25551	\N	\N	\N	ABDIJALIL ALI 	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25552	\N	\N	\N	ABDULMONEM ALI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25553	\N	\N	\N	Hamdi Ibrahim	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25554	\N	\N	\N	Abdi Ali nuriye	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25555	\N	\N	\N	Quintter Mbaria	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25556	\N	\N	\N	IBRAHIM MOHAMED IBRAHIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25557	\N	\N	\N	MARTHA MATHARA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25558	\N	\N	\N	MARK MAKAU	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25559	\N	\N	\N	ZAITUNI MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25560	\N	\N	\N	HASSAN MOHAMED TONDOO	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25561	\N	\N	\N	ALI BAKARI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25563	\N	\N	\N	OMAR	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25564	\N	\N	\N	SAMEER OSMAN OSMAN ABDALLA	\N	1	NOT ON THE OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25565	\N	\N	\N	FATIMA MOHAMED	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25566	\N	\N	\N	ASLI ISMAIL	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25567	\N	\N	\N	Said Abdu Anwar	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25568	\N	\N	\N	HALIMA AHMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25569	\N	\N	\N	ISSA MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25570	\N	\N	\N	SALIM MUHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25571	\N	\N	\N	PAUL MUTIGA JOHN	\N	1	does not appear on the ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25572	\N	\N	\N	HASSAN MAHAMED	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25573	\N	\N	\N	HASSAN A AHMED BWANAKAI	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25574	\N	\N	\N	AHMED ABDALLA RAMADHAN	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25575	\N	\N	\N	FUAD MOHAMED ESMAIL	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25576	\N	\N	\N	MOHAMED ABDUL RAHMAN ABDA HASSAN	\N	1	Not on OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25577	\N	\N	\N	JULIUS DAVID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25578	\N	\N	\N	MWAMADI SWALEH 	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25579	\N	\N	\N	SAIDA SAID SALIM MWABEGE	\N	1	Name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25580	\N	\N	\N	SAMIRA ABDALLA\t	\N	1	not on the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25581	\N	\N	\N	SAMIRA ABDALLA	\N	1	Not on Ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25582	\N	\N	\N	JOY JOY	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25583	\N	\N	\N	NAHIDA MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25584	\N	\N	\N	KHALIFA ABDULLA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25585	\N	\N	\N	YUSSUF MOHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25586	\N	\N	\N	ABDALLA ALI RAMADHAN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25587	\N	\N	\N	ABDUL RAHIM AHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25588	\N	\N	\N	DAHIRU IBRAHIM	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25589	\N	\N	\N	HUSSEIN MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25590	\N	\N	\N	ALI SAAD SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25591	\N	\N	\N	ANDREW NJOROGE\t	\N	1	Not on the OFAC List 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25592	\N	\N	\N	MUSTAFA MOHAMED MWAPAKA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25593	\N	\N	\N	MOUHAMED SWALEH	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25594	\N	\N	\N	HASSAN MOHAMMED CHIMAKO	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25595	\N	\N	\N	SHARIFFA MOHAMMED	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25596	\N	\N	\N	KISIA KISIA	\N	1	Not on OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25597	\N	\N	\N	MADINA SAID MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25598	\N	\N	\N	AMINA MOHAMMAD	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25599	\N	\N	\N	AHMED IBRAHIM	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25600	\N	\N	\N	JOSPHAT MAINA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25601	\N	\N	\N	AHMED KHALID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25602	\N	\N	\N	Victor  Njoroge	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25603	\N	\N	\N	SOFIA SAID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25604	\N	\N	\N	YUSUF ATHMAN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25605	\N	\N	\N	HALMA MOHAMED ALI	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25606	\N	\N	\N	NASSER MOHAMMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25607	\N	\N	\N	ALTECH RIGGING SYSTEM LIMIT	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25608	\N	\N	\N	MOHAMED SULEIMAN  BADI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25609	\N	\N	\N	AMAN HASSAN NASSOR	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25610	\N	\N	\N	ALIMASI KULUBWA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25611	\N	\N	\N	STANLEY MAINA	\N	1	not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25612	\N	\N	\N	JUMA MOHAMED FADHILI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25613	\N	\N	\N	HAFSABANU BASHIR NOORANI	\N	1	AML  VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25614	\N	\N	\N	HAFSABANU BASHIR  NOORANI	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25615	\N	\N	\N	MOHAMMAD RASHID MBWANA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25616	\N	\N	\N	MAUREEN PATRICK	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25620	\N	\N	\N	safiya tarash	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25621	\N	\N	\N	Mohamed Hassan Gure	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25622	\N	\N	\N	Cabdi Nuur	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25623	\N	\N	\N	Fuad mahamed Husein	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25624	\N	\N	\N	ADEDE PETER JOEL AWINO	\N	1	AML TIMEOUT ERROR	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25625	\N	\N	\N	ELIZABETH NYAMBURA IRUNGU	\N	1	AML TIMEOUT ERROR	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25626	\N	\N	\N	GLADNESS WALI KAPALLA	\N	1	AML TIMEOUT ERROR	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25627	\N	\N	\N	Ali Mahamad	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25628	\N	\N	\N	ABDULLATIFF ABDULLAHI	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25629	\N	\N	\N	RAJAB HAMIS	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25632	\N	\N	\N	OMAR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25633	\N	\N	\N	SAMEER OSMAN ABDALLA	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25634	\N	\N	\N	USAMA IDIUSAMA	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25635	\N	\N	\N	HASSAN KASSIM	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25636	\N	\N	\N	DANSTON ONDACHII	\N	1	Double paid client through CBA	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25637	\N	\N	\N	LYDIA MUTHONDU	\N	1	Double paid client through CBA	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25638	\N	\N	\N	Ange Vumiriya	\N	1	Erroneously paid	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25639	\N	\N	\N	Kimani Wambui	\N	1	Erroneously paid	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25640	\N	\N	\N	John Muiruri	\N	1	Erroneously paid	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25641	\N	\N	\N	ZULA SALIMIN ZULA	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25642	\N	\N	\N	MOHAMED  HUSSEIN	\N	1	.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25643	\N	\N	\N	OMAR MOHAMMAD NAAMAN 	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25644	\N	\N	\N	OMAR MOHAMMAD NAAMAN	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25645	\N	\N	\N	JOSEPH ORETA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25646	\N	\N	\N	JOSEPH ORETA \t	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25647	\N	\N	\N	JOSEPH ORETA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25648	\N	\N	\N	JUMA H JUMA	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25649	\N	\N	\N	HASSAN HAMED RAFIU	\N	1	NOT ON OFAC  LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25650	\N	\N	\N	MOSES KARANJA MOSES KARANJA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25651	\N	\N	\N	BADRIE ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25652	\N	\N	\N	HUSNA HUSSEIN ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25653	\N	\N	\N	MOHAMED HUSSEIN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25654	\N	\N	\N	YUSUF ANOOR YUSUF	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25655	\N	\N	\N	KHALID SAIF AL ABDUL SALAM	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25656	\N	\N	\N	MARIANNE SILA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25657	\N	\N	\N	HAMISA ABDI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25658	\N	\N	\N	Ali Mohamud Mohamed	\N	1	GOVERNOR MARSABIT CONSTITUECY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25659	\N	\N	\N	KHADIJA AHMED HASSANKHADIJA AHMED HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25660	\N	\N	\N	KHADIJA AHMED HASSAN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25661	\N	\N	\N	JORUM MALANDA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25662	\N	\N	\N	ALI SAID ABDUL RAHMAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25663	\N	\N	\N	JUMA ALI ALI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25664	\N	\N	\N	MOHAMED KHALID SOOD	\N	1	NOT FOUND ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25665	\N	\N	\N	NURU ABDALLA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25666	\N	\N	\N	KUBRA KUBRA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25667	\N	\N	\N	SAID ABDUL RAHMAN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25668	\N	\N	\N	NOOR RWASA ALI NOOR	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25669	\N	\N	\N	MOHAMAD SWALEH OMAR	\N	1	Name not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25670	\N	\N	\N	ISSA AHMED ISSA	\N	1	Name not in the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25671	\N	\N	\N	RAHMA ALI MOHAMEED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25672	\N	\N	\N	HAMISI HAMAD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25673	\N	\N	\N	HASSAN MOHD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25674	\N	\N	\N	SAMUEL OPUKA ORIWO	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25675	\N	\N	\N	MOHAMED SWALEH KHAMIS	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25676	\N	\N	\N	ISHA MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25677	\N	\N	\N	MOHAMED ABDULLA SEIF	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25678	\N	\N	\N	ZAYYAD SWALEH MOHAMED RASHID	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25679	\N	\N	\N	GRACE GACHIE	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25680	\N	\N	\N	YUNUS MUHAMMAD	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25681	\N	\N	\N	SAID R SAID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25682	\N	\N	\N	YUNUS MUHAMMAD 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25683	\N	\N	\N	EVAS  	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25684	\N	\N	\N	NATHAN OSIEMO OTAO	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25685	\N	\N	\N	OMAR SAID OMAR	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25686	\N	\N	\N	RAHIMA ABDULKADER	\N	1	Not on OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25687	\N	\N	\N	ABDIRAHIM MOHAMUD	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25688	\N	\N	\N	MWANAISHA HASSAN	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25689	\N	\N	\N	BEN BOGENI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25690	\N	\N	\N	HASSAN MOHAMED SHEE	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25691	\N	\N	\N	AHMED ASHRAF AHMED	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25692	\N	\N	\N	SAFINA OMARI OMARI	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25693	\N	\N	\N	tito	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25694	\N	\N	\N	MARY MARY	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25695	\N	\N	\N	VICTOR NJOROGE	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25696	\N	\N	\N	VICTOR  NJOROGE	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25697	\N	\N	\N	SAIDI MOHAMMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25698	\N	\N	\N	SIMON LYANGA LYANGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25699	\N	\N	\N	LINDA OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25700	\N	\N	\N	AWADH BAKARI AWADH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25701	\N	\N	\N	ANWAR AMIN MOHAMED HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25702	\N	\N	\N	ALI ABDILLAHI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25703	\N	\N	\N	Ibrahin Muhumed	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25704	\N	\N	\N	SALIM HAMAD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25705	\N	\N	\N	AYUB ABDALLA RAMADHAN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25706	\N	\N	\N	JAMAL MOHAMED AHMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25707	\N	\N	\N	EDWIN DWINO 	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25708	\N	\N	\N	EDWIN DWINO	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25709	\N	\N	\N	HALIMA ABUBAKER	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25710	\N	\N	\N	FAHID MOHAMED	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25711	\N	\N	\N	YAHYA MOHAMED ALI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25712	\N	\N	\N	OMAR ADAM OMAR	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25713	\N	\N	\N	SALEEM AHMAD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25714	\N	\N	\N	MUHAMED BAKARI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25715	\N	\N	\N	AHMED EBRAHIM JIVANJEE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25716	\N	\N	\N	MGENI ABDALLAH ISMAIL	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25717	\N	\N	\N	ALBERT NJOROGE NDUNGU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25718	\N	\N	\N	JOSE MARIA WANJAU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25719	\N	\N	\N	SULEIMAN KATANI MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25720	\N	\N	\N	HUSSEIN MOHAMMED GULEID	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25721	\N	\N	\N	MWANAMKASI OMARI MATABISHI	\N	1	Not appearing on the Ofac List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25722	\N	\N	\N	VICTOR VICTOR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25723	\N	\N	\N	MUSA HAMIS	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25724	\N	\N	\N	ALII JUMA MAMBRUI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25725	\N	\N	\N	BRENDA WALI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25726	\N	\N	\N	MAINA MAINA	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25727	\N	\N	\N	HUSNA ALI	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25728	\N	\N	\N	ABDALLA HASSAN MWAKAGA	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25729	\N	\N	\N	SULEIMAN AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25730	\N	\N	\N	JAMAL MOHAMED NASEER	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25731	\N	\N	\N	MWANAKOMBO MOHAMMED HASAN	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25732	\N	\N	\N	MOHAMED HASSAN JUMA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25733	\N	\N	\N	ABDALLA SHEIKH AHMED BADAWY	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25734	\N	\N	\N	MOHAMED SALIM SALIM	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25735	\N	\N	\N	HASSAN IBRAHIM HASSAN	\N	1	NOT ON THE OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25736	\N	\N	\N	JUMA ABDUL ABDALLA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25737	\N	\N	\N	ZAHRA HAJJI	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25738	\N	\N	\N	SWALEH AHMED YUSUF\t	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25739	\N	\N	\N	HUSSEIN ABDALLAH	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25740	\N	\N	\N	SALIMA NASSER\t	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25741	\N	\N	\N	MOHAMED ABUBAKAR	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25742	\N	\N	\N	SALIMA NASSER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25743	\N	\N	\N	MAIMUNA MOHAMED SAID	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25744	\N	\N	\N	AHMED SHADAU	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25745	\N	\N	\N	SHEE MOHAMMED SHEE	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25746	\N	\N	\N	ABDULRAHMAN ISMAIL ABDALLAH	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25747	\N	\N	\N	MOHAMED SHUKRI MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25748	\N	\N	\N	MOHAMED FARID	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25749	\N	\N	\N	JOAN JERONO 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25750	\N	\N	\N	SAUDA HUSEIN MOHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25751	\N	\N	\N	AMINA MOHAMMAD 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25752	\N	\N	\N	Saraphinah Abubaker Odhiambo	\N	1	Customer was paid but transaction cancelled	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25753	\N	\N	\N	MOHAMED SALIM YAHYA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25754	\N	\N	\N	ASHA ABDI GARAD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25755	\N	\N	\N	MUHAMMED BAKARI NWASHAMBI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25756	\N	\N	\N	ALII DHDHA MOHAMED	\N	1	Not on the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25757	\N	\N	\N	MOHAMMED ALI ABDALLA	\N	1	not on the OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25758	\N	\N	\N	AHMED KHAMIS AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25759	\N	\N	\N	KASSIM MOHAMED CHIBOHE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25760	\N	\N	\N	HASSAN MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25761	\N	\N	\N	RUKIYA SWALEH MOHAMED	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25762	\N	\N	\N	ELIZABETH MWAURA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25763	\N	\N	\N	ADHAM AHMED ABDULLRHMAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25764	\N	\N	\N	ABDALLAH SALIMU	\N	1	not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25765	\N	\N	\N	NAUSHAD 	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25766	\N	\N	\N	TSHOUKALADAKIS TAKY TAKY 	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25767	\N	\N	\N	TSHOUKALADAKIS TAKY TAKY	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25768	\N	\N	\N	MOHAMED ALI KAMIL	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25769	\N	\N	\N	ELIZABETH ELIZABETH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25770	\N	\N	\N	MOHAMED MAHMOUD	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25771	\N	\N	\N	ABDIRAHMAN AHMED HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25772	\N	\N	\N	LATIFA ALI IBRAHIM	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25773	\N	\N	\N	KNIGHT KNIGHT	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25774	\N	\N	\N	HUSSNA OMAR	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25775	\N	\N	\N	SWALEH MOHAMED JUMA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25776	\N	\N	\N	RAJAB HUSSEIN ABDULLAH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25777	\N	\N	\N	FAHAD ADIL MOHAMMAD	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25778	\N	\N	\N	SAIDA MOHAMED ABDALLA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25779	\N	\N	\N	MOHAMMED JAMAL SAAD	\N	1	The name does not exist of OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25780	\N	\N	\N	JANET MAINA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25781	\N	\N	\N	MUHAMMAD ABDU ABDURAHMAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25782	\N	\N	\N	HAMAD RAMA HAMADI	\N	1	Not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25783	\N	\N	\N	JANET MAINA 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25784	\N	\N	\N	MUHAMMAD ABDU  ABDURAHMAN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25785	\N	\N	\N	ANNA ANYANGO	\N	1	not on ofac ist	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25786	\N	\N	\N	SHAMSA MOHAMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25787	\N	\N	\N	MOHAMED SAID MAMDIN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25788	\N	\N	\N	SWABRA AMIN MOHAMED AHMAD OBO	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25789	\N	\N	\N	FABIANAS .	\N	1	Not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25790	\N	\N	\N	MUSTAFA ALI	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25791	\N	\N	\N	FABIANAS 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25792	\N	\N	\N	ASHA AHMED ISMAIL	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25793	\N	\N	\N	SALIM MOHAMED SALEH	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25794	\N	\N	\N	SAID KHALIF	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25795	\N	\N	\N	Abdirizak Mohamed	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25796	\N	\N	\N	Hussein Abdullahi	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25797	\N	\N	\N	samira mohamud	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25798	\N	\N	\N	ABDULLAHI HUSSEIN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25799	\N	\N	\N	IBRAHIM CHARO	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25800	\N	\N	\N	MOHAMED SULEIMAN OMAR	\N	1	NOT FOUND ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25801	\N	\N	\N	Ali Dhahir	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25802	\N	\N	\N	BANURA IBRAHIM MOHAMMED	\N	1	NAME NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25803	\N	\N	\N	FUAD MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25804	\N	\N	\N	MARY ODEK	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25805	\N	\N	\N	NAHYA IBRAHIM	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25806	\N	\N	\N	HALIMA MUSA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25807	\N	\N	\N	Martin Tindi	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25808	\N	\N	\N	Asha Hassan omar	\N	1	NOT FOUND ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25809	\N	\N	\N	RASHIDA ABDUL FAZAL	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25810	\N	\N	\N	HASSAN SUDI HASSAN	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25811	\N	\N	\N	ABDI MUHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25812	\N	\N	\N	GEORGE KARANJA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25813	\N	\N	\N	HALIMO ABDI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25814	\N	\N	\N	AHMED MOHAMED	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25815	\N	\N	\N	MOHAMMED KHAMIS	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25816	\N	\N	\N	ANISA OMAR MOHAMMAD	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25817	\N	\N	\N	YASSIR ABDUL AZIZ SOMOEBWANA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25818	\N	\N	\N	IBRAHIM MOHAMED IBRAHIM 	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25819	\N	\N	\N	FADHWILL ABBAS MOHMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25820	\N	\N	\N	ATHMAN AHMAD	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25821	\N	\N	\N	FAWZI ABDULLA ALI JUMA	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25822	\N	\N	\N	Mohamed Suleiman Badi	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25823	\N	\N	\N	FRANCIS NDELESI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25824	\N	\N	\N	MOHAMMED SAID MWANYAMBO	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25825	\N	\N	\N	SALIM TWAHA SALIM	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25826	\N	\N	\N	HASSAN NURU	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25827	\N	\N	\N	ABDUBA ALI	\N	1	not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25828	\N	\N	\N	MUMIA MUHAMMAD SWALEH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25829	\N	\N	\N	ABDALLA SALIM	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25830	\N	\N	\N	AMALL MOHAMED	\N	1	NOT ON THE OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25831	\N	\N	\N	JOSHUA AMONDE	\N	1	Name not in the OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25832	\N	\N	\N	KHADIJA MOHAMMED	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25833	\N	\N	\N	ISMAIL FUAD ISMAIL	\N	1	The name does not exist on ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25834	\N	\N	\N	HAMADI RAMA HAMADI	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25835	\N	\N	\N	MUHAMAD LALI MUHAMAD	\N	1	Not found on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25836	\N	\N	\N	MOHAMED SWALEH	\N	1	not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25837	\N	\N	\N	FAHAD AHMED AHMED ABDI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25838	\N	\N	\N	BADRIE ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25839	\N	\N	\N	DAVID ANDAWA\t	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25840	\N	\N	\N	JOHN PAUL MULEI	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25841	\N	\N	\N	MOHAMED MOHAMUD ABDI	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25842	\N	\N	\N	HADIJA ALI\t	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25843	\N	\N	\N	DAVID ANDAWA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25844	\N	\N	\N	SULEIMAN SWALEH MUHAMMAD	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25845	\N	\N	\N	HADIJA ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25846	\N	\N	\N	MOHAMED ABDULKARIM MOHAMEDALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25847	\N	\N	\N	HAFSWA ABDALLAH\t	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25848	\N	\N	\N	HAFSWA ABDALLAH	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25849	\N	\N	\N	RASHIDA RASHIDAH	\N	1	not on the ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25850	\N	\N	\N	MOHAMED ALI BANA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25851	\N	\N	\N	MOHAMMED SULEIMAN ONGURO ALI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25852	\N	\N	\N	HUSSEIN ALI HUSSEIN	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25853	\N	\N	\N	KASSIM AHMED	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25854	\N	\N	\N	MOHAMMAD ALI HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25855	\N	\N	\N	JOHN PAUL MBUGUA KIRUIYA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25856	\N	\N	\N	FAHAD ABDULAZIZ MOHAMED AHMED	\N	1	aml failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25857	\N	\N	\N	RASHIDA ISSA RASHID MWAJI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25858	\N	\N	\N	HASSAN AWADH HASSAN	\N	1	not on the OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25859	\N	\N	\N	ABDUL LATIF HUSSEIN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25860	\N	\N	\N	SOFIA ABDALLAH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25861	\N	\N	\N	EVAS	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25862	\N	\N	\N	MWANASHA HUSSEIN MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25863	\N	\N	\N	MOHAMED JUMAA	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25864	\N	\N	\N	MOHAMED  JUMAA	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25865	\N	\N	\N	Abdulkader Saleh	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25866	\N	\N	\N	AMANI ALI	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25867	\N	\N	\N	JUMA JOHN JUMA	\N	1	Name Flagged due to the common name Juma, however the name has a false match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25868	\N	\N	\N	ABDALLAH MWIDADI ABDALLAH	\N	1	Name flagged due to the common name ABDALLAH, however it does not match from the listed on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25869	\N	\N	\N	MOHAMED SAID  MAMDIN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25870	\N	\N	\N	ASHA ABDALLA HASSAN ELKINDY	\N	1	Name does not appear in the sanction List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25871	\N	\N	\N	MOHAMED JUMA	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25941	\N	\N	\N	FADHILA ZAHRAN MOHAMED ELAUFY~KEN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25872	\N	\N	\N	NANCY ISAAC ISAAC	\N	1	Name flagged due to the common name Issac however its not associated to the name sanctioned on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25873	\N	\N	\N	ABDIRAHMAN ABDULLAHI  MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25874	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25875	\N	\N	\N	IBRAHIM  HAJI	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25876	\N	\N	\N	ASHLEY ACHIENG OCHIENG	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25877	\N	\N	\N	HUSSEIN ABDI OMAR\t	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25878	\N	\N	\N	ALI ABDILLAH ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25879	\N	\N	\N	AHMED AHMED	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25880	\N	\N	\N	AHMED MOHAMED ABDUL MALIK	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25881	\N	\N	\N	OMARI HASAN ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25882	\N	\N	\N	MOHAMED KHAMIS SWALEH	\N	1	Name flagged due to the common name MOHAMED however the sanctioned individual does not match or associated with the individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25883	\N	\N	\N	GRACE BAYA	\N	1	Name flagged due to the common name GRACE however the sanctioned name is an entity from IRAN name as 'GRACE BAY SHIPPING INC' hence why its a FALSE match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25884	\N	\N	\N	MAHMUD SWALEH ALI	\N	1	Name flagged due to the common name SWALEH however his other names rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25885	\N	\N	\N	ELIZABETH MAIMA	\N	1	Name flagged due to ELIZABETH however her other name and nationality rules her out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25886	\N	\N	\N	GODWIN MUTUNGA	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25887	\N	\N	\N	FARIDA HASSAN	\N	1	Name flagged due to the common name HASSAN however her other name rules her out from the sanctioned who is male.hence why have released transaction.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25888	\N	\N	\N	HAMID AHMED SHRIFF	\N	1	Not on the ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25889	\N	\N	\N	HABIBA ALI ABDI	\N	1	Name flagged due to the common name HABIBA however what rules him out is current location and his other names yet the sanctioned individual is a PEP from Syria	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25890	\N	\N	\N	HASSAN  NOOR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25891	\N	\N	\N	ABDULLAHI NOOR  HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25892	\N	\N	\N	GEORGE ARENDE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25893	\N	\N	\N	FARIDA SAID	\N	1	The sanctioned is an entity in Pakistan, flagged due cause of the name SAID however the flagged individual is a NATURAL person in KENYA hence why i ruled out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25894	\N	\N	\N	MOHAMEDAMIN ABDALLA MOHAMEDAMIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25895	\N	\N	\N	ABDULLAHI ABDI AHMED	\N	1	Full name on ID: Abdullahi Abd Ahmed, ID no: 26293726, YOB: 1989, Current Loc: Kenya, his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25896	\N	\N	\N	JOHN KANANI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25897	\N	\N	\N	ABDULLAHI ABD AHMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25898	\N	\N	\N	ABDI ADEN GARAD	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25899	\N	\N	\N	ABDI  ADEN GARAD	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25900	\N	\N	\N	ABDI ADEN  GARAD 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25901	\N	\N	\N	ABDULLAHI ABD  AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25902	\N	\N	\N	ALI SALIM ALI	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25903	\N	\N	\N	RAMADHAN JUMA ABDALLAH	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25904	\N	\N	\N	SAID ALI SAID	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25905	\N	\N	\N	HALIMO ABDULLAHI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25906	\N	\N	\N	ABDUL MAJID NASSOR SALIM	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25907	\N	\N	\N	YASIN ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25908	\N	\N	\N	MOHAMED ABUD	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25909	\N	\N	\N	HARUN MOHAMED HARUN	\N	1	The sanctioned individual does not match the flagged individual hence no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25910	\N	\N	\N	ABDALLA HASSAN MWACHITSEKO	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25911	\N	\N	\N	KHALID ALI MOHAMED BAKARI	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25912	\N	\N	\N	RICHARD NGARI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25913	\N	\N	\N	ABDULMALIK SWALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25914	\N	\N	\N	ABDALLAH OMAR	\N	1	False match on OFAC however his other names rules him out from the common name ABDALLAH.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25915	\N	\N	\N	HASSAN OMAR KANYOE	\N	1	Beneficiary full names: Hassan Omar Kanyoe, Kenyan ID: 13852400, YOB:1975, Current Loc: Kenyan.Hence has no relation to the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25916	\N	\N	\N	HASSAN OMARKANYOE	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25917	\N	\N	\N	SALIM ALI JUMA	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25918	\N	\N	\N	MARIAM SULTAN	\N	1	Cancelled txn	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25988	\N	\N	\N	HABIB RASHID AHMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25989	\N	\N	\N	 ABDULLAHI HASSAN	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25919	\N	\N	\N	ALI ABASI	\N	1	Full name on Kenyan ID: ALI Abba Khariff, ID No: 30279611, DOB: 13.11.1993, From Mombasa kisauni. Nationality Kenyan. this rules him out from the sanctioned indivuduals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25920	\N	\N	\N	AHMED MOSTAFA MOHAMED ZINELDIN	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25921	\N	\N	\N	ZAHIR AKRAM  AKRAM	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25922	\N	\N	\N	AMIN ALI	\N	1	Full names: Amin Ali Abdallah, DOB:01.01.1957, ID no:8231337, cur loc: Mombasa Kenya. Hence has 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25923	\N	\N	\N	PETER KIMOTHO	\N	1	Received cash erroneously	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25924	\N	\N	\N	ABDILLAH MOHAMED ABDI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25925	\N	\N	\N	SAIDA SAIDI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25926	\N	\N	\N	SAID  MOHAMMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25927	\N	\N	\N	HASSAN HAMAD HASSAN MARIAKA	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25928	\N	\N	\N	ALI BARAK	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25929	\N	\N	\N	ABDULRAHMAN ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25930	\N	\N	\N	AMIN MOHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25931	\N	\N	\N	JUMA SALIM MUHAMMAD	\N	1	Name flagged is SALIM however his other names rule him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25932	\N	\N	\N	SALIM A SALIM	\N	1	Identification provided	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25933	\N	\N	\N	KELVIN KELVIN NJUGUNA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25934	\N	\N	\N	ABDUL MALIK MEHBOOB MUHSIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25935	\N	\N	\N	SAIDA MBULA SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25936	\N	\N	\N	SALIM RASHID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25937	\N	\N	\N	ALI SIYAKA ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25938	\N	\N	\N	SHIDI RASHID MSOMALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25939	\N	\N	\N	ASHLEY ACHIENG  OCHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25940	\N	\N	\N	RAHMA ALI	\N	1	Name flagged due to common name ALI however the name does not match with the name sanctioned on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25942	\N	\N	\N	BARIKE ABUD	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25943	\N	\N	\N	SALIM A	\N	1	Name:Salim Abdulrahman Ahmed,DOB:11/04/1994,Nationality:Kenyan,Current Loc:Bahrain,PPno:AK0044290	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25944	\N	\N	\N	YAHYA MOHAMMAD WALID	\N	1	The name does exist OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25945	\N	\N	\N	WIDAD ABDULLA AHMED	\N	1	Name does not match from the one flagged on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25946	\N	\N	\N	GONZLE MARIA	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25947	\N	\N	\N	KAHLID ABBAS MOHAMMED	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25948	\N	\N	\N	TOFIC RASHID	\N	1	Name flagged due to the common name RASHID however what rules him out is his other name TOFIC from the sanctioned individual on OFAC who is a GENERAL from Palestine.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25949	\N	\N	\N	ABDIFATAH HASSAN  NOOR	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25950	\N	\N	\N	MOHAMMED ABUD MCHENI	\N	1	Name flagged due to the common name mohammed however his other names rules him out from the sanctioned individuals on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25951	\N	\N	\N	HASSAN ALI OMAR	\N	1	Name flagged due to the common name OMAR however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25952	\N	\N	\N	YASIN RAMADHANI	\N	1	Name flagged due to the common name YASIN however his other name rules him out from the sanctioned individuals whose other names differentiate him.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25953	\N	\N	\N	FATHMA ALI	\N	1	Name flagged due to the common name ALI however the person flagged is a female from the once on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25955	\N	\N	\N	MUHAMMAD SALLEH KIMUSULA	\N	1	Full name: Mohamed Swaleh Kimuswa, YOB:1987, Kenyan ID: 26226414, Current locations: Likoni, Mombasa Kenya, has no relation with the sanctioned individual on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25956	\N	\N	\N	SAID ABDALLAH MUHAMMAD	\N	1	Name flagged due to the common name Muhammad however the sanctioned individual on OFAC was a Former Minister in Iraq hence why no relation to the flagged individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25957	\N	\N	\N	AHMED ALI AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25958	\N	\N	\N	OMAR MWALIMU OMAR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25959	\N	\N	\N	HALIMA MOHAMED SULEIMAN	\N	1	Sanctioned individual is Male while HALIMA is female.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25960	\N	\N	\N	MAURINE ORIA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25961	\N	\N	\N	MOHAMED AHMED 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25962	\N	\N	\N	AHMED ALI ABDALLA	\N	1	Name flagged due to the common name AHMED ALI however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25963	\N	\N	\N	OMAR MBARK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25964	\N	\N	\N	OLIVIA JASMINE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25965	\N	\N	\N	ABDULLAHI ABDI  AHMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25966	\N	\N	\N	ABDIRAHMAN MOHAMED ELEMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25967	\N	\N	\N	ABDUL KADIR MOHAMED	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25968	\N	\N	\N	HASSAN MWATUNYA SALIM	\N	1	Name flagged due to common name salim however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25969	\N	\N	\N	ABBAS SALIM	\N	1	Full name: Abbas Salim Ali, KE pp no: A2016002, DOB: 25/05/1990, Cur loc: Qatar, Nationality: Kenyan. his other name ALI rules him out from the sanctioned individuals. 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25970	\N	\N	\N	ALBERT KAMAU NJOROGE	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25971	\N	\N	\N	ZUHURA AHMED HASSAN	\N	1	AML AILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25972	\N	\N	\N	JANE  WATIRI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25973	\N	\N	\N	ABDULRAHMAN MOHAMED HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25974	\N	\N	\N	JANE WATIRI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25975	\N	\N	\N	ZAINAB MOHAMED  HUSSEIN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25976	\N	\N	\N	MOHAMED IMAN  ABDI	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25977	\N	\N	\N	HALIMA SULEIMAN	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25978	\N	\N	\N	ANDREW BARAKA	\N	1	Name flagged due to the name BARAKA however the sanctioned is an entity from dubai which rules him out or has no relation or association.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25979	\N	\N	\N	ABDALLAH SALIM	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25980	\N	\N	\N	ABDALLAH SALIM 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25981	\N	\N	\N	CALLEB ASIAGO	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25982	\N	\N	\N	IBRAHIM AHMED RAJAB	\N	1	the name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25983	\N	\N	\N	HUSSEIN ATHMAN HUSSEIN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25984	\N	\N	\N	MOMO OMAR MUHAMMED	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25985	\N	\N	\N	CHARLES HAMZA HAMZA	\N	1	Name flagged due to HAMZA however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25986	\N	\N	\N	ABDULRAHMAN MOHAMED SAID	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25987	\N	\N	\N	AMINA MOHAMED WAIRIMU	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25990	\N	\N	\N	ABDULLAHI  HASSAN	\N	1	Customer Full name:Bille Abdullahi Hassan, DOB: 14/02/1985, Kenyan Passport No:A1705883, from Isiolo Kenya has no relation to the sanctioned individual who other name BILLE rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25991	\N	\N	\N	ABBAS MOHAMED MOHAMED	\N	1	Name flagged is MOHAMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25992	\N	\N	\N	MOHAMED MOHAMUD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25993	\N	\N	\N	ABDALLAH  ABUBAKAR AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25994	\N	\N	\N	KHALIFA MUHAMMAD	\N	1	flagged due to the common name Khalifa however his other name does not match his the name sanctioned or associated to the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25995	\N	\N	\N	MOHAMED ABDUL MUSA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25996	\N	\N	\N	NASSIM MOHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25997	\N	\N	\N	MASOUD SURURU MASOUD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25998	\N	\N	\N	SALIMA ALI BAKARI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	25999	\N	\N	\N	OMAR MASUDI OMAR	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26000	\N	\N	\N	MOHAMUD ADAN MUHAMED	\N	1	Name flagged is MUHAMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26001	\N	\N	\N	MUHAMMAD ABUBAKAR MADDY	\N	1	Name has a false match on OFAC hence has no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26002	\N	\N	\N	HAMAD MBARAK	\N	1	False Match on OFAC flagged to the name Mbarak however on ofac its Barrak	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26003	\N	\N	\N	SAAD MOHAMED SWALEH	\N	1	False Match.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26004	\N	\N	\N	BASHIR MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26005	\N	\N	\N	ALI MOHAMMAD ABDULLA	\N	1	Name flagged due to the common name ABDULLA however its a false match on OFAC due to the third name.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26006	\N	\N	\N	ANNA PAOLA MARIA MINUTO	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26007	\N	\N	\N	KASSIM ABUBAKAR MOHAMED	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26008	\N	\N	\N	BAKARI MDACHI BAKARI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26009	\N	\N	\N	BILAL FUAD BILAL	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26010	\N	\N	\N	AMINA ABDALLA ISLAM	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26011	\N	\N	\N	MUHAMMAD SALLEH KIMUSULA\t	\N	1	Full name: Mohamed Swaleh Kimuswa, YOB:1987, Kenyan ID: 26226414, Current locations: Likoni, Mombasa Kenya, has no relation with the sanctioned individual on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26012	\N	\N	\N	SWALLEH ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26013	\N	\N	\N	N JASI JASI MAGUMBA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26014	\N	\N	\N	ZAITUN ALI 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26015	\N	\N	\N	KHALIF JUMA	\N	1	False Match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26016	\N	\N	\N	OMAR ATHUMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26017	\N	\N	\N	SALAMA HASSAN	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26018	\N	\N	\N	ANWAR AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26019	\N	\N	\N	MOHAMED  ABDI MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26149	\N	\N	\N	ISMAIL ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26020	\N	\N	\N	GIDEON KIBET GIDEON	\N	1	The flagged individual is GIDEON the governor of Reserve Bank of Zimbabwe, hence why transaction was released.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26021	\N	\N	\N	HASSAN SHARAMO	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26022	\N	\N	\N	MARY MWAURA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26023	\N	\N	\N	ABDULLAHI NOOR HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26024	\N	\N	\N	ALEZ MAINA MAINA	\N	1	False match on OFAC no relation or association to the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26025	\N	\N	\N	MARYAM OMAR	\N	1	The name sanctioned on OFAC is a vessel hence why transaction was released.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26026	\N	\N	\N	MUHAMMAD RAJAB	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26027	\N	\N	\N	SHAFIQ MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26028	\N	\N	\N	AHMED HEMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26029	\N	\N	\N	CLARA LILIAN MTONYI	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26030	\N	\N	\N	KIM KIMANI	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26031	\N	\N	\N	ABDIQAFAR MOHAMED	\N	1	Name flagged was due to the common name MOHAMED however his other names rule him out from the sanctioned individuals on OFAC and UNlist.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26032	\N	\N	\N	CAROINE MANGARI	\N	1	False match on OFAC since the name sanctioned is different from the name provided.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26033	\N	\N	\N	ABUBAKER AHMED	\N	1	Full name on ID: ABUBAKAR AHMAD SABUR, ID No:30346490, DOB:03.09.1993, Cur Loc: Kenya. Hence why this rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26034	\N	\N	\N	ZAINAB MOHAMED HUSSEIN	\N	1	Name flagged due to the common name Mohamed Hussein however his other names rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26035	\N	\N	\N	AMIRI ABDALLA	\N	1	Full name as per Kenyan ID:AMIRI ABDALLA, ID no:9789841, DOB: 24.06.1969, Current LOc: Kenya, hence why he has no association with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26036	\N	\N	\N	MARIAM BADI	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26037	\N	\N	\N	ABDALLA MOHAMMED ABDALLA	\N	1	Name flagged due to name ABDALLA however his other names rules him out from the sanctioned individuals and no association.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26038	\N	\N	\N	AHMED NOOR AHMED	\N	1	Flagged name is AHMED however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26039	\N	\N	\N	ASHURA MOHAMED HUSEIN	\N	1	False match on OFAC due to the name flagged from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26040	\N	\N	\N	ANWAR AMIN MOHAMMAD	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26041	\N	\N	\N	MOHAMMED LAMIN MOHAMMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26042	\N	\N	\N	ABDALLAH  SALIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26043	\N	\N	\N	ALI YASIN ALI	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26044	\N	\N	\N	MOHAMED FAHIM ABDUN	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26045	\N	\N	\N	ABDUL MOHAMED AMIN	\N	1	Name nit in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26046	\N	\N	\N	TUNA OMAR TUNA	\N	1	The flagged individuals name does not match the sanctioned individual hence has no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26047	\N	\N	\N	RAHMA HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26048	\N	\N	\N	HAMDI EBRAHIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26049	\N	\N	\N	SWALEH MOHAMED CHOU	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26050	\N	\N	\N	ALIFA SULEIMAN MOHAMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26051	\N	\N	\N	ABDI SULEIMAN\t	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26052	\N	\N	\N	ABDI  SULEIMAN	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26053	\N	\N	\N	DAVID MBANDI	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26054	\N	\N	\N	REHEMA ALI MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26055	\N	\N	\N	HABA HABA TRAVEL  SERVICES LIMITED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26056	\N	\N	\N	THOMAS LANGAT	\N	1	The name flagged is THOMAS but his other names rules him out from the sanctioned individual due to nationality.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26057	\N	\N	\N	AHMED SALIM	\N	1	Full name: Ahmed Salim Ahmed, Nationality: Kenyan, DOB: 11/11/1993, State of Qatar ID no:29340400527, Expiry Date: 04/03/2020. Current loc: QATAR.  	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26058	\N	\N	\N	FATIMA MOHAMMED	\N	1	Name flagged MOHAMMED however the beneficiary is a female and the sanctioned individuals are males hence does not appear to be associated.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26059	\N	\N	\N	ASAD AHMED	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26060	\N	\N	\N	IBRAHIM HASSAN ALI	\N	1	Full name: Ibrahim Hassan Ali, DOB: 01/01/1985, State of Qatar: 28540400292, ED: 01/07/2020, Kenyan PP no: A1871047, Nationality: Kenyan, Cur Loc: QATAR. has no association with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26061	\N	\N	\N	OMAR OMAR MWINYIFAKI	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26062	\N	\N	\N	SALIM AHMED	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26063	\N	\N	\N	SAMIRA ABDUL	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26064	\N	\N	\N	AMINA MOHAMM	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26065	\N	\N	\N	AHMED SAYYED SAID HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26066	\N	\N	\N	MOHAMMED GHALIB	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26067	\N	\N	\N	ABDI  NOOR MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26068	\N	\N	\N	DYER AND BLAIR  INVESTMENT BANK LIMITED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26069	\N	\N	\N	ABDUL KASSIM MOHAMMED	\N	1	Kenyan ID no: 27574270, DOB:18/11/1989, POB: Kibera Kenya.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26070	\N	\N	\N	NABILA MOHAMMAD	\N	1	Name flagged due to name Nabila however false match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26071	\N	\N	\N	FAUZIA MUHAMMAD ISLAM	\N	1	Name does not appear in the Sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26072	\N	\N	\N	MOHAMMAD SALIM MAULI	\N	1	Name does not appear in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26073	\N	\N	\N	HUSSEIN  ABDI OMAR	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26074	\N	\N	\N	HEMED SWALEH MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26075	\N	\N	\N	SAYED YASSIR ALLI QADRI\t	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26076	\N	\N	\N	SAYED YASSIR ALLI QADRI	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26077	\N	\N	\N	JOHN THAIRU	\N	1	Name flagged on OFAC is JOHN HARUN a PEP in Kenya however our client is not associated or related to the PEP.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26078	\N	\N	\N	ABEID AWADH ABEID	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26079	\N	\N	\N	SWABRI MOHAMED ABUD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26080	\N	\N	\N	OMAR MOHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26081	\N	\N	\N	MWAMAD SWALEH 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26082	\N	\N	\N	ALICE KARIMI KARIMI	\N	1	Flagged due to the name KARIMI yet the sanctioned individual name is KARIM a former Agriculture minister IRAQ, what rules her out is his MALE.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26083	\N	\N	\N	ABDUL RAHMAN SULEIMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26084	\N	\N	\N	JIMAL MOHAMED MOHAMED	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26150	\N	\N	\N	AHMED SESE HAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26085	\N	\N	\N	GEORGE GEORGE	\N	1	False match on OFAC since the sanctioned individual is based in Zimbambwe	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26086	\N	\N	\N	ERNESTO GONZALEZ ESTRADA	\N	1	Full name: Gonzalez Estrada Ernesto, DOB: 06/04/1971, Mexican Passport no: G18526423, Expiry Date: 04/03/2026, POB: District Federal. what rules him out is the year of birth, third name, and Place of Birth. Passport provided by Transfast.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26087	\N	\N	\N	GABRIELE FONTANA	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26088	\N	\N	\N	ENOCK OLANDO	\N	1	The name flagged is an ENTITY yet this is a natural person hence why they doent have any relation since his third name is ESHIOKHUNJILA	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26089	\N	\N	\N	RABIA MOHAMMED SALEH	\N	1	The name does not exist on Ofac.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26090	\N	\N	\N	MOHAMED SHARIF	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26091	\N	\N	\N	AHMAD KHALID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26092	\N	\N	\N	FOZIA HUSSEIN MOHAMED	\N	1	Name flagged due to the common name HUSSEIN & MOHAMED however what rules her out is her other name from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26093	\N	\N	\N	IBRAHIM ABDUL	\N	1	ID received from partner	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26094	\N	\N	\N	ABDI ADEN  GARAD	\N	1	aml verification	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26095	\N	\N	\N	AHMED ALI SHEIKH	\N	1	Name flagged due to common name AHMED however his other names rules him out from the sanctioned individuals on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26096	\N	\N	\N	JANE WATIR	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26097	\N	\N	\N	CHAZON  CAPITAL GROUP	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26098	\N	\N	\N	RAFI NGALA MOHAMED	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26099	\N	\N	\N	ABDUL ALI	\N	1	Name flagged due common name ALI however his other name rules him out from the sanctioned individual who was arrested.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26100	\N	\N	\N	ABDALLAH HASSAN	\N	1	Name flagged due to common name HASSAN however his other name rules him out from the sanctioned individual from IRAQ	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26101	\N	\N	\N	ABBAS ALIY SARAI	\N	1	Flagged due to the common name ABBAS however his other names rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26102	\N	\N	\N	HALIMA   SULEIMAN  	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26103	\N	\N	\N	MOHAMMED HUSSEIN	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26104	\N	\N	\N	KEVIN KEVIN	\N	1	ID PROVIDED	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26105	\N	\N	\N	ABDUL SALIM	\N	1	The name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26106	\N	\N	\N	JEFFERSON MUTHAMA MUTHAMA	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26107	\N	\N	\N	MBARAK HAMIS MBARAK	\N	1	Name flagged is MBARAK however the sanctioned individual has no association hence why have released.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26108	\N	\N	\N	KAHDIJA ABDULLAHI ABDUL RAHMAN	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26109	\N	\N	\N	AHMED SHARIFF DIN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26110	\N	\N	\N	ABDUL JABBAR ABDALLA	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26111	\N	\N	\N	RIZIKI IBRAHIM MOHAMED	\N	1	False match on sanction lists since his other name RIZIKI rules him out from the sanctioned who appear to be from Saudi Arabia.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26112	\N	\N	\N	JUMA ABDULLA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26113	\N	\N	\N	FATMA SAID MOHAMED	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26114	\N	\N	\N	WAHAB ABDU MUHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26115	\N	\N	\N	ZAITUN MOHAMED ABUD	\N	1	False match on OFAC hence why her other names rules her out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26116	\N	\N	\N	HABIBA BISHAR ABDI ABDI\t	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26117	\N	\N	\N	ABDULKADIR MJAHID ABDULKADIR	\N	1	NOT IN OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26118	\N	\N	\N	MUSTAFA MOHAMED ABDI	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26119	\N	\N	\N	ALI HUSSEIN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26120	\N	\N	\N	ABDULKADIR MOHAMED ABDULKADIR	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26121	\N	\N	\N	ABDALLAH ATHMAN ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26122	\N	\N	\N	ABDALLA MWALIMU ALI	\N	1	Name flagged ALI however his other names rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26123	\N	\N	\N	CAROLINE MAIRA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26124	\N	\N	\N	JOSEPH MURAYA	\N	1	Name flagged JOSEPH however his other name rules him out plus the sanctioned individual is a PEP.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26125	\N	\N	\N	SAMIA MOHAMED ABDALLA	\N	1	Name flagged due to the common name MOHAMED however his others names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26126	\N	\N	\N	ABDIRAHMAN ABDULLAHI MOHAMED	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26127	\N	\N	\N	SULEIMAN MOHAMED OMAR	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26128	\N	\N	\N	DYER AND BLAIR INVESTMENT BANK LIMITED	\N	1	Name flagged due to name INVESTMENT same as the sanctioned however the full name is not flagged.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26129	\N	\N	\N	HASSAN HAMAD MWANYOA	\N	1	Flagged due to common name HASSAN however his other names rule him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26130	\N	\N	\N	MGENI SAID MOHAMED	\N	1	Flagged due to MOHAMED however its a false match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26131	\N	\N	\N	MOHAMMED KHALID AMESA	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26132	\N	\N	\N	MOHAMED SAID MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26133	\N	\N	\N	ABDIFATAH HASSAN NOOR	\N	1	The person flagged on OFAC is a Female yet our client is male, hence False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26134	\N	\N	\N	IBRAHIM ABDULLAHI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26135	\N	\N	\N	SHAZIA ABDUL HAMID SATTAR	\N	1	Not on Ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26136	\N	\N	\N	ABDHUL MAJID SHAFFI	\N	1	False Match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26137	\N	\N	\N	MWANKOMBO HASSAN MOHAMED CHIMWENJE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26138	\N	\N	\N	SULEIMAN ABDALLA KAMA	\N	1	Name flagged due to the common name ABDALLA however his other names rules him out from the sanctioned Individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26139	\N	\N	\N	MOHAMED AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26140	\N	\N	\N	MOHAMAD ABUBAKAR MUHDHAR	\N	1	Name flagged due to the common name MOHAMAD however his other names rules him out from the sanctioned individual on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26141	\N	\N	\N	NURU MALINDI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26142	\N	\N	\N	ABDULRAZAK MOHAMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26143	\N	\N	\N	HUSSAIN HUSAIN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26144	\N	\N	\N	HASSAN NOOR	\N	1	Not on OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26145	\N	\N	\N	AARIF SHARIFF	\N	1	Not in OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26146	\N	\N	\N	AINDA RICHARD JOHN	\N	1	Name flagged due to the common name JOHN however what rules him out is his last name from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26147	\N	\N	\N	CECILA MARIFA	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26148	\N	\N	\N	FRANCIS MAUNDU	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26151	\N	\N	\N	MASOUD MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26152	\N	\N	\N	ALI KHAMIS ALI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26153	\N	\N	\N	ABUL RAHMAN FUAD MOHAMAED LAABID	\N	1	Name not on OFAC List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26154	\N	\N	\N	MBARAK SAID MBARAK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26155	\N	\N	\N	SALIM HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26156	\N	\N	\N	SALMIN AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26157	\N	\N	\N	ABDULLAHI  ABDI AHMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26158	\N	\N	\N	DENG CHOL  DENG	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26159	\N	\N	\N	KHALID ABBAS MOHAMMED	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26160	\N	\N	\N	HASSAN MWATUNYA  SALIM	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26161	\N	\N	\N	AZIZA SALIM ABDULLAH	\N	1	Name flagged due to common name AZIZA however the sanctioned individual was arrested in 2002 with no bail. however his other names rules his out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26162	\N	\N	\N	MOHAMED SALIIM MOHAMED	\N	1	Full name on Passport: Mohamed Mohamed Salim, PP no:B020223, DOB:22 march 1984, Current location:UAE, POB: Lamu,KENYA. Hence why no relation to the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26163	\N	\N	\N	FAUD AHMED SAAD AHMED SAAD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26164	\N	\N	\N	ABDI MOHAMED AMIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26165	\N	\N	\N	ABDI  MOHAMED AMIN	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26166	\N	\N	\N	HUSNA MUSTAFA MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26167	\N	\N	\N	SIKUKUU OMAR EBRAHIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26168	\N	\N	\N	HABIB MWALIMBU AHMED	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26169	\N	\N	\N	JANE WATIRI	\N	1	FALSE MATCH ON OFAC, UN AND EU SANCTION LIST.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26170	\N	\N	\N	MUBARK AWAD MBARAK	\N	1	Name flagged due to the name MUBARK however his other names rules him out from the sanctioned list.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26171	\N	\N	\N	MOHAMMED SAID	\N	1	Name flagged due to common name MOHAMMED however the sanctioned individual is a PEP in IRAQ hence why they have no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26172	\N	\N	\N	MOHAMED IMAN ABDI	\N	1	Flagged due to ABDI however his other names rule him out hence why he has no association to the sanctioned individual	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26173	\N	\N	\N	ALI MOHAMED  ABDALLAH	\N	1	Full name: ALI MOHAMED ABDALLA, ID no: 8534023, DOB: 13.12.1967, Mombasa Kenyan hence why no association with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26174	\N	\N	\N	ABUBAKAR ABDULRAHMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26175	\N	\N	\N	RUKIA HAJI MOHAMMED	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26176	\N	\N	\N	BARIKA HASSAN ALI	\N	1	Not on Ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26177	\N	\N	\N	KASSIMU MOHAMMED YUSUF	\N	1	The name does not exist on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26178	\N	\N	\N	MOHAMMED AHMED HUSSEIN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26179	\N	\N	\N	SAIDA SAID MOHAMED	\N	1	Name does not exist on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26180	\N	\N	\N	MOHAMMED MATANO	\N	1	False match OFAC since the name flagged is Mohammed however the names sanctioned do not match his other names.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26181	\N	\N	\N	CHARLES HAMZA  HAMZA	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26182	\N	\N	\N	MOHAMED ABDUL HALIM	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26183	\N	\N	\N	ABDULLAHI HASSAN	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26184	\N	\N	\N	CHOLE SHAMA	\N	1	False match on OFAC since the name sanctioned is totally different from the customer hence why the transaction has been released.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26185	\N	\N	\N	IBRAHIM MUNYI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26186	\N	\N	\N	SAAD SALIM SAAD	\N	1	Full names:SAAD SALIM SAAD, Kenyan ID no: 4997079, DOB:23/08/1955, Current loc: KENYA, hence why he has no relation or association with the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26187	\N	\N	\N	AHMED MOHAMED ISSA	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26188	\N	\N	\N	ADEL FOUAD ELSAYED HELMY ELSAYED	\N	1	Full name: Elsayed Adel Fouad Elsayed Helmy, DOB:29.06.1964, Nationality: Egyptian, Current Loc: UAE, Expiry Date:09/04/2020, He has no association with the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26189	\N	\N	\N	SABIS INTERNATIONAL SCHOO SCHOOL	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26190	\N	\N	\N	MUSTWALIK ABDULRAHMAN MOHAMED	\N	1	Name flagged due to the common name Mohammed however his other 2 names differentiate him.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26191	\N	\N	\N	IBRAHIM HAJI	\N	1	Full name Haji Ibrahim Ahmed, DOB19/09/1976,Canadian born in Somalia.hence no false match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26192	\N	\N	\N	ABDI NOOR MOHAMED	\N	1	Name flagged due to common name ABDI however the name on ID rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26193	\N	\N	\N	MESRLIMU ABDHALLA	\N	1	False match on OFAC from the name flagged on our system.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26194	\N	\N	\N	FADHILA ZAHRAN MOHAMED ELAUFY	\N	1	Kenyan ID- 1896461, DOB:01/01/1950, Mombasa Kenyan hence false match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26195	\N	\N	\N	BASHIR  MOHAMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26196	\N	\N	\N	SHAFFI AHMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26197	\N	\N	\N	ABDUL KARIM OMAR NASSER	\N	1	The name does not exist.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26198	\N	\N	\N	HUSSEIN ABDULLAHI NYAGA	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26199	\N	\N	\N	ABDULHALIM ABDULAZIZ	\N	1	Name provided does not match with the name flagged on OFAC hence its a false Match.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26200	\N	\N	\N	MUHAMMAD SALLEHKIMUSULA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26201	\N	\N	\N	IBRAHIM SALIM HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26202	\N	\N	\N	ZAITUN ALI	\N	1	The sanctioned individual is a male from IRAQ and currently serving time hence why have released the transaction.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26203	\N	\N	\N	TOMA MOHAMMED OMALLA	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26204	\N	\N	\N	GEORGE MANDELA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26205	\N	\N	\N	SULEIMAN GHARIB SULEIMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26206	\N	\N	\N	FATMA MOHAMED SULTAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26207	\N	\N	\N	MERCY  MERCY	\N	1	FUll name: Mercy Njeri Wanjiru, Kenyan ID no: 36917827, DOB:12/07/1999. 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26208	\N	\N	\N	KHADIJA OMAR IBRAHIM	\N	1	not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26209	\N	\N	\N	MOHAMMAD AHMED OMAR	\N	1	False match on OFAC. flagged due to common name Mohammed however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26210	\N	\N	\N	AHMED ABDALLAH RAMADHANI 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26211	\N	\N	\N	HANI FOUAD MOHAMED SALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26212	\N	\N	\N	ABDUL TWALIB ALI	\N	1	Name flagged due to the common name ABDUL & ALI with the sanctioned individual who was arrested in 2002 however his third name rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26352	\N	\N	\N	IBRAHIM MOHAMED ABDALLAH	\N	1	Not on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26353	\N	\N	\N	AHMED HASHIM AHMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26213	\N	\N	\N	ALI NASSER	\N	1	Full name: Ali Nasser Mulellah, DOB:20/11/1973, UAE resident ID- 784-1973-0619351-3. Current location: UAE, Nationality: Kenyan. Hence why the individual has no relation or association to the sactioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26214	\N	\N	\N	AHMED ABUBAKAR AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26215	\N	\N	\N	FARHA AWADH	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26216	\N	\N	\N	FELIX OBELIX	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26217	\N	\N	\N	SHEE MWINYI SHEE	\N	1	False match the sanctioned is a Vessel.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26218	\N	\N	\N	 ABDULLAHI  ABD AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26219	\N	\N	\N	ALI RASHID RASI	\N	1	AML Failure	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26220	\N	\N	\N	SAIDA ABUDI MOHAMED	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26221	\N	\N	\N	SALIM SULEMAN MOHAMMAD	\N	1	Name flagged due to common name SALIM however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26222	\N	\N	\N	CHAZON CAPITAL GROUP	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26223	\N	\N	\N	DUNIA MOHAMED MOHAMED	\N	1	Flagged due to the common name MOHAMED however his other name rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26224	\N	\N	\N	IDDI SALIM SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26225	\N	\N	\N	<ABDALLAH SALIM            	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26226	\N	\N	\N	ABEID SAID	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26227	\N	\N	\N	SANA HASSAN	\N	1	Name flagged is HASSAN however its a common name hence why no association to the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26228	\N	\N	\N	MOHAMED ALI FAKI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26229	\N	\N	\N	ABDI SULEIMAN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26230	\N	\N	\N	ABDI SULEIMAN 	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26231	\N	\N	\N	ABDALLAH ABUBAKAR AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26232	\N	\N	\N	ABDALLAH  ABUBAKAR  AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26233	\N	\N	\N	AMIR MAHMOUD MOHAMED	\N	1	False match on OFAC name flagged is MOHAMED which is a common name his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26234	\N	\N	\N	RASHID ABDUL OUKO	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26235	\N	\N	\N	ATHMAN ABDUL	\N	1	Beneficiary ID provided	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26236	\N	\N	\N	RUKIA SALIM MUHAMMED	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26237	\N	\N	\N	HABIBA BISHAR ABDI ABDI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26238	\N	\N	\N	IBRAHIM SHABAN	\N	1	Not on OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26239	\N	\N	\N	OMAR MANGARI HASSAN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26240	\N	\N	\N	MOHAMED HASSAN OMAR	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26241	\N	\N	\N	HALID AHMED MOHAMMED	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26242	\N	\N	\N	MOHAMED BARE ABDI	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26243	\N	\N	\N	HALID AHMED MOHAMMED 	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26244	\N	\N	\N	HASSAN ABDULLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26245	\N	\N	\N	SAIF MOHAMMED SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26246	\N	\N	\N	MOHAMED JUMA SULEIMAN HAMID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26247	\N	\N	\N	ORINA ORINA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26248	\N	\N	\N	AMINA MOHAMMED YUSUF	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26249	\N	\N	\N	SAIDA HABIBI MOHAMED	\N	1	Name flagged due to the common name MOHAMED however the flagged individual is a female and the sanctioned individuals are male PEPs from IRAQ hence has no association.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26250	\N	\N	\N	MUHAMMAD ALI	\N	1	Name flagged is MUHAMMAD however after going through the sanctioned individual the is not associated with the flagged person.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26251	\N	\N	\N	ZAHIR AKRAM AKRAM	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26252	\N	\N	\N	ZAHIR  AKRAM AKRAM	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26253	\N	\N	\N	KARAMA SAMIR KARAMA	\N	1	Name flagged on OFAC does not match with the clients name provided.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26254	\N	\N	\N	MOHAMED OMAR MOHAMED	\N	1	Kenyan ID-12897363, DOB:01/01/1973, from kwale, Mombasa Kenya. hence no relation to the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26255	\N	\N	\N	HUSSEIN AHMED HUSSEIN	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26256	\N	\N	\N	AHMAD HASSAN ABDALA	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26257	\N	\N	\N	578938633	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26258	\N	\N	\N	LINET ACHIENG	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26259	\N	\N	\N	HUSSEIN ABDI OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26260	\N	\N	\N	SALIM ALI SALIM	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26261	\N	\N	\N	MBARAK ABDALLA MBARAK AWADH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26262	\N	\N	\N	KAHLID ABBAS MOHAMMED\t	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26263	\N	\N	\N	JANE OMARIBA	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26264	\N	\N	\N	MWAMAD SWALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26265	\N	\N	\N	JOHN CHARO	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26266	\N	\N	\N	ABDALLA ZAMZAM	\N	1	Name is not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26267	\N	\N	\N	MOHAMAD ABDULSHAKUR ABUBAKAR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26268	\N	\N	\N	SAMUEL OFULA	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26269	\N	\N	\N	ISSA IBRAHIM 	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26270	\N	\N	\N	BIASHA HASSAN	\N	1	False Match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26271	\N	\N	\N	AHMED ABDALLAH RAMADHANI	\N	1	Name flagged due to the common names RAMADHANI ABDALLAH however his current location, third name rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26272	\N	\N	\N	Amos Juma Odiwour	\N	1	Was paid after txn was cancelled	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26273	\N	\N	\N	ESHA ABDILLAH MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26274	\N	\N	\N	HAMID AHMED SHARIFF	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26275	\N	\N	\N	DENG CHOL DENG	\N	1	Full name on passport: Chol Deng Chol Deng, Passport No: R004851737, DOB: 25.07.1985, Expiry Date:01.02.2024, Occupation: Student, Nationality: South Sudan. Name flagged was an Entity after EDD he has no relation to the sanctioned individuals on OFAC. 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26276	\N	\N	\N	NADIA OMAR AWADH	\N	1	Full name on Qatar residence ID: 2834040039, DOB:09/02/1983, Cur Loc: QATAR, Nationality: KENYAN, PPNo: A2158517, EXP Date: 01/04/2024.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26277	\N	\N	\N	OMAR HASSAN ALLY	\N	1	False match on OFAC his other names rules him out from sanctioned OMAR	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26278	\N	\N	\N	ABDULLAHI  ABD AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26279	\N	\N	\N	ABDUL MALIK MOHAMMED ABDU	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26280	\N	\N	\N	FATMA MOHAMED SAID	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26281	\N	\N	\N	AHMED SHRIFF SHATRY	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26282	\N	\N	\N	AMRAN MOHAMED ADAN	\N	1	Name flagged due to the common name ADAN however his other names and current location rule him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26283	\N	\N	\N	RAJAB ABDULRAHAMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26284	\N	\N	\N	ALI MOHAMED ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26285	\N	\N	\N	ABDULKADER SALEH	\N	1	False Match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26286	\N	\N	\N	DAVID ADERO	\N	1	False match on OFAC since the sanctioned individual is Colombian.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26287	\N	\N	\N	AWADH AHMED AWADH	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26288	\N	\N	\N	 ABDALLAH SALIM 	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26289	\N	\N	\N	ABEID SAID 	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26290	\N	\N	\N	ABDULKADIR AHMED HUSSEIN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26291	\N	\N	\N	YUSUF ALI YUSUF MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26292	\N	\N	\N	JUDITH JUDITH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26293	\N	\N	\N	ZEINAB ABDUL RAHIM	\N	1	Not on OFAC list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26294	\N	\N	\N	FATMA KASSIM MOHAMED	\N	1	False match on OFAC since the name provided does not match the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26295	\N	\N	\N	BARE ABDULLAHI HASSAN	\N	1	False match on sanction lists since his other name BARE rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26296	\N	\N	\N	HALIMA ABDALLA	\N	1	Name flagged due to name ABDALLA however the her other name rules her out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26297	\N	\N	\N	LULU AHMAD IBRAHIM	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26298	\N	\N	\N	REBA REBA CHEPTAI	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26299	\N	\N	\N	HABA HABA TRAVEL SERVICES LIMITED	\N	1	The name flagged is SERVICES LTD however his other names HABA HABA rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26300	\N	\N	\N	HABA HABA  TRAVEL SERVICES LIMITED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26301	\N	\N	\N	SULEIMAN OMAR MUHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26302	\N	\N	\N	MOHAMMED HUSSEIN MZONGE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26303	\N	\N	\N	SAIDA HABIBI  MOHAMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26304	\N	\N	\N	HUSEIN MOHAMED SHEE	\N	1	False match on OFAc name flagged does not match or have any association with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26305	\N	\N	\N	RAMADHAN SALIM RAMADHAN	\N	1	Full name: Ramadhan Salim Ramadhan, DOB: 27.04.1984, Kenyan ID: 24161012, Current Loc: UAE, Resident ID: 784-1984-9863193-0. Hence has no association with the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26306	\N	\N	\N	PAULINE MORAA  KINYANJUI\t	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26307	\N	\N	\N	RAJAB AHMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26308	\N	\N	\N	MOHAMED LALI MOHAMED	\N	1	AML VERIFICATION 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26309	\N	\N	\N	HABIBA ALI ABD	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26310	\N	\N	\N	AHMED LALI	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26311	\N	\N	\N	ESHA AMIR AMRI	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26312	\N	\N	\N	ABDUL HAMID ABDUL RAHMAN\t	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26313	\N	\N	\N	ABDUL HAMID ABDUL RAHMAN	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26314	\N	\N	\N	ABDUL RAHMAN SAHA	\N	1	Name flagged on due to the common name ABDUL however his other names differentiates him from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26315	\N	\N	\N	OMARI IBRAHIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26316	\N	\N	\N	SAID SALIM SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26317	\N	\N	\N	SAID MOHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26318	\N	\N	\N	SAID  SALIM SAID	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26319	\N	\N	\N	DAVID NZAKA MUTA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26320	\N	\N	\N	RUTH NDUTA NJENGA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26321	\N	\N	\N	MERCY MUKOA KHAKAME	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26322	\N	\N	\N	HARRISON KIHARA MWANGI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26323	\N	\N	\N	TWAHIR ALI	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26324	\N	\N	\N	MOHAMED SALIM RASHID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26325	\N	\N	\N	ALI SULEIMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26326	\N	\N	\N	SAIDI ABDALLAH MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26327	\N	\N	\N	ATHMAN MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26328	\N	\N	\N	MARTHA MARTHA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26329	\N	\N	\N	ALEX MAUNGE MAUNGE	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26330	\N	\N	\N	FAHD JAMAL	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26331	\N	\N	\N	ABDILLAHI ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26332	\N	\N	\N	SADIK ABDALLA HAMAD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26333	\N	\N	\N	KHALI  ALI	\N	1	Name flagged due to the common name ALI however his other name KHALI rules him out from the sanctioned who was arrested.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26334	\N	\N	\N	FURSIYAH ABDULLAH MOHAMED	\N	1	Name flagged is ABDULLAH however his other names, location rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26335	\N	\N	\N	MURSHID MOHAMMED KASSIM	\N	1	False match on OFAC due to name MOHAMMED same as the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26336	\N	\N	\N	FATMA ABDUL REHMAN	\N	1	Sanctioned is MALE yet our client is female.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26337	\N	\N	\N	MASIKA MOHAMMED	\N	1	FALSE match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26338	\N	\N	\N	KHAMIS NAMANI KHAMIS	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26339	\N	\N	\N	FATUMA MOHAMMED ABDILLAH	\N	1	Name flagged is MOHAMMED same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26340	\N	\N	\N	DENNIS PILSI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26341	\N	\N	\N	ALI MOHAMED ABDALLA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26342	\N	\N	\N	MARY WAITHIRA MARY WAITHIRA	\N	1	AML VERIFICATION NAME NOT ON THE OFAC LIST , NAMES REPEATED	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26343	\N	\N	\N	MOMO OMAR MUHAMAD	\N	1	Name flagged OMAR same as the sanctioned however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26344	\N	\N	\N	MOHAMMED SAID KALENDI	\N	1	Name flagged is on SAID same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26345	\N	\N	\N	SAID ABDI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26346	\N	\N	\N	NAHEEDA MOHAMMED YOUSUF	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26347	\N	\N	\N	JOHN PAUL ORUMA	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26348	\N	\N	\N	KAREN KORAENY TAIWA KAREN KORAENY TAIWA	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26349	\N	\N	\N	RAFIDA MOHAMED	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26350	\N	\N	\N	ESHA MOHAMED YUSUF	\N	1	N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26351	\N	\N	\N	HADI SAID ABDALLAH	\N	1	Full names: Hadi Said Abdalla Basawad, DOB: 13/06/1983, State of Qatar Id no: 28340400001, Nationality: Kenyan, Cur Location: Qatar. hence has no relation or association to the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26354	\N	\N	\N	YUSUF RASHID MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26355	\N	\N	\N	HALIMAX MOHAMED SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26356	\N	\N	\N	ABDULHAKIM AMIR 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26357	\N	\N	\N	HUSSAIN JAMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26358	\N	\N	\N	ADAM SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26359	\N	\N	\N	SALIM MWAFRIKA SALIM	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26360	\N	\N	\N	HASSAN AHMED SAID	\N	1	Not on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26361	\N	\N	\N	KASSIM MOHAMED MWAGOGO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26362	\N	\N	\N	KHAMIS NASSER KHAMIS	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26363	\N	\N	\N	SWALEH SAID SWALEH OMAR ABOUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26364	\N	\N	\N	HOODA MOHAMED ABDI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26365	\N	\N	\N	AMIN ABDULLHI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26366	\N	\N	\N	NAIMA SHARIF MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26367	\N	\N	\N	AHMED ABDULLAHI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26368	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26369	\N	\N	\N	ABDUL MANAN	\N	1	ABDUL MANAN	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26370	\N	\N	\N	OMAR HABASH OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26371	\N	\N	\N	MOHAMED TUFEL ESMAIL NOOR MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26372	\N	\N	\N	SALIM MUSA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26373	\N	\N	\N	MOHAMED TUFEL ESMAIL  NOOR MOHAMED\t	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26374	\N	\N	\N	ALI HOSSAIN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26375	\N	\N	\N	Mohnamed Osman Hussein	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26376	\N	\N	\N	WINNLE MWI HAKI HAKI MACHARIA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26377	\N	\N	\N	MOHAMMED BAKAR	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26378	\N	\N	\N	MANSOOR MANSOOR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26379	\N	\N	\N	SALIM MOHAMED ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26380	\N	\N	\N	HASSAN AHMAD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26381	\N	\N	\N	LETISHIA ACHIENG OCHIENG	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26382	\N	\N	\N	MOHAMED SULEIMAN ALI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26383	\N	\N	\N	MUSTAFA MWAKIO	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26384	\N	\N	\N	ABDUL AZIZ OWOUR MUNDA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26385	\N	\N	\N	ANSWAR MOHAMED SHARIFF	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26386	\N	\N	\N	OMAR ALI AWADH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26387	\N	\N	\N	AMINA MOHAMED SHAFI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26388	\N	\N	\N	JAMILA SHABAN	\N	1	No matching results on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26389	\N	\N	\N	ABDALLA SHARIFF AHMED IMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26390	\N	\N	\N	HASSAN ABDALLAH	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26391	\N	\N	\N	STEIZY MUTHONI MUTHONI	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26392	\N	\N	\N	John Ndichu Thuo	\N	1	Double paid client on 09/12/2019	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26393	\N	\N	\N	HAMADI SULEIMAN SAMBI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26394	\N	\N	\N	MOHAMMED AMIR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26395	\N	\N	\N	AMINA ABDALLAH MOHAMMAD	\N	1	Not on  OFAC list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26396	\N	\N	\N	AHMED MOHAMED MBARAK	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26397	\N	\N	\N	AMINA AMIN SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26398	\N	\N	\N	AMOS GITHINJI KABIA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26399	\N	\N	\N	JOSE VINCENTE FRANCI DESOUZA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26400	\N	\N	\N	MOHAMED RAJAB KASSIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26401	\N	\N	\N	ROSALINDA MUGO	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26402	\N	\N	\N	PAULINE WANGUI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26403	\N	\N	\N	NAFISA OMAR AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26404	\N	\N	\N	HUSSEIN SAID OMAR	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26405	\N	\N	\N	ALFAN AHMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26406	\N	\N	\N	ABDUL AZIZ ALI TABU	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26407	\N	\N	\N	ALBINA KARIMI KARIMI	\N	1	False match the beneficiary name flagged is KARIMI almost the same as KARIM a PEP in IRAQ. hence no association with the individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26408	\N	\N	\N	JAMAL BALALA	\N	1	Name flagged is JAMAL however his other name rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26409	\N	\N	\N	SWALEH MOHAMED BAKARI	\N	1	False match on sanction list.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26410	\N	\N	\N	MOHAMED ALI HASSAN	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26411	\N	\N	\N	ABDALLA OMAR	\N	1	NAME FLAGGED DUE TO COMMON NAME OMAR HOWEVER HIS OTHER NAMES RULES HIM OUT FROM THE SANCTION LIST.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26412	\N	\N	\N	MOHAMED ALI MOHAMOUD	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26413	\N	\N	\N	CECILIA NDERI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26414	\N	\N	\N	Kante	\N	1	.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26415	\N	\N	\N	ALYE MOHAMED ABDULLAZIZ	\N	1	Name flagged ABDULLAZIZ from the sanctioned individual however his other names and current location rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26416	\N	\N	\N	HAMISI ALI 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26417	\N	\N	\N	ZUHURA YAHYA MOHAMMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26418	\N	\N	\N	ABDUL MALIK NGUI MUTISO	\N	1	Name flagged is ABDUL same as the sanctioned individual however his other names rules him out	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26419	\N	\N	\N	MARIMA MOHAMED HUSSEIN	\N	1	Name is not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26420	\N	\N	\N	ALII SAIDI ALI	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26421	\N	\N	\N	MOHAMED ABDI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26422	\N	\N	\N	ABDULLAHI ALI MOHAMED	\N	1	fALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26576	\N	\N	\N	NASSIM MOHAMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26423	\N	\N	\N	SALIM HASSAN MWALUPS	\N	1	Name flagged due to the common name HASSAN same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26424	\N	\N	\N	TOMAS OCHIENG OCHIENG	\N	1	False Match on OFAC name flagged is CHENG however it does not match with the clients name.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26426	\N	\N	\N	RODGERS OTIENO	\N	1	Client was double paid	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26428	\N	\N	\N	AMAN SAAD AMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26429	\N	\N	\N	YUSUF SALIM YUSUF	\N	1	Name flagged due to the common name YUSUF however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26430	\N	\N	\N	SUBEIDA MOHAMED SULEMAN	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26431	\N	\N	\N	YUSUF HASSAN ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26432	\N	\N	\N	WARDA AHMED SALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26434	\N	\N	\N	BASHEIKH MOHAMED	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26435	\N	\N	\N	 JAMAL MOHAMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26436	\N	\N	\N	HASSAN AMAR MOHAMMAD	\N	1	AML VERIFICATION	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26437	\N	\N	\N	MOHAMED  ABDULAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26438	\N	\N	\N	OMAR  MOHAMED  BWANAOBO	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26439	\N	\N	\N	OMAR MOHAMED BWANAOBO 	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26440	\N	\N	\N	YUNIS HADI FARAJ SAAD	\N	1	Name flagged is YUNIS same as the sanctioned however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26441	\N	\N	\N	FATUMA SHARIFF AHMED SHARIFF	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26442	\N	\N	\N	MOHAMMED DUWALE FARA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26443	\N	\N	\N	ABDULHAKIM  AMIR	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26444	\N	\N	\N	HASSAN MOHAMED  NDERITU	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26445	\N	\N	\N	SAID ABEID	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26446	\N	\N	\N	MARY WERE WERE	\N	1	FALSE RESULT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26447	\N	\N	\N	MARY WERE WERE 	\N	1	FALSE RESULT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26448	\N	\N	\N	SULTAN ALII SAID	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26449	\N	\N	\N	MOHAMED YUSUF BISHARO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26450	\N	\N	\N	AHMED SWALEH ABDALLA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26451	\N	\N	\N	FLORAH BUKANIA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26452	\N	\N	\N	JUMA  SAID	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26453	\N	\N	\N	SALIM MURAD SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26454	\N	\N	\N	MOHAMED HASSANI OMAR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26455	\N	\N	\N	AHMED  ABDULLAHI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26456	\N	\N	\N	MOHAMED TUFEL ESMAIL  NOOR MOHAMED 	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26457	\N	\N	\N	MOHAMED TUFEL ESMAIL  NOOR MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26458	\N	\N	\N	SAND RIVER ECO CAMP LTD SAND RIVER ECO CAMP LTD	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26459	\N	\N	\N	MOHAMMED NEMWA IBRAHIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26460	\N	\N	\N	FAHAD SAGAR AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26461	\N	\N	\N	ALI MAHMOUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26462	\N	\N	\N	MSABAHA ABEID MSABAH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26463	\N	\N	\N	Rahma H Abdi	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26464	\N	\N	\N	MARTIN MARTIN	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26465	\N	\N	\N	UBA ALWI ABDALLA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26466	\N	\N	\N	MOHAMED HAJI	\N	1	FALSE MATCHING RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26467	\N	\N	\N	KHALID WALID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26468	\N	\N	\N	HASSAN ABDALLA MWANGANGA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26469	\N	\N	\N	AHMED HUSSEIN MOHAMMAD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26470	\N	\N	\N	SAMIRA ABDI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26471	\N	\N	\N	MUSTAFA JAMAL AWADH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26472	\N	\N	\N	JUMA JUMA SUYA	\N	1	OKAY 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26473	\N	\N	\N	ABDULKADIR SALIM ABDULKADIR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26474	\N	\N	\N	SUSAN ACHIENG OCHIENG	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26475	\N	\N	\N	ISSA ATHMAN MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26476	\N	\N	\N	ALI ABDULLAH KHALIL	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26477	\N	\N	\N	JOSHUA MAINA WACHANGA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26478	\N	\N	\N	ALI MAHMOUD ALI	\N	1	Not on OFAC List 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26479	\N	\N	\N	AYUB ABDUL RAHMAN	\N	1	Not on OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26480	\N	\N	\N	SAID ABDU MLINGO	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26481	\N	\N	\N	SAID ABDU  MLINGO 	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26482	\N	\N	\N	RASHID ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26483	\N	\N	\N	MAHAMED HUSSEIN MUMIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26484	\N	\N	\N	AMINA MOHAMED ADAM	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26485	\N	\N	\N	FATHI SAID ABUD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26486	\N	\N	\N	AMIN HASSAN	\N	1	Name flagged is HASSAN however his other name and current location rules him out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26487	\N	\N	\N	SUNDAY SUDAN	\N	1	Full name: Sunday Joan Sudan, DOB: 12/05/1991, PP no: R00448881, Cur Loc: Kenyan.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26488	\N	\N	\N	ALBERT MOSE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26489	\N	\N	\N	ALI HEMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26490	\N	\N	\N	MARGRATE NDUTA GITAU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26491	\N	\N	\N	JANIFFER WANJIRU GITHAIGA	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26492	\N	\N	\N	M BATIA	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26493	\N	\N	\N	BIHIJA ABDUL SWAMAD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26494	\N	\N	\N	NYANGITO AND ASSOCIATES NYANGITO AND ASSOCIATES	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26495	\N	\N	\N	HUSSEIN KHALID HUSSEIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26496	\N	\N	\N	MOHAMED ABDULRAZAK SALIM	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26497	\N	\N	\N	AMINA IBRAHIM MUHAMMED	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26498	\N	\N	\N	MZAMIL MOHAMMAD ATIK	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26499	\N	\N	\N	YUSUF AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26500	\N	\N	\N	RAMADHAN  MOHAMMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26501	\N	\N	\N	SALIM SUDI JUMA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26502	\N	\N	\N	OMAR HASSAN ABDALLA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26503	\N	\N	\N	HOUSE AND FARM COMPANY LIMITED 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26504	\N	\N	\N	MOHAMED HUSSEIN ABDALLA	\N	1	Name flagged is HUSSEIN same as the sanctioned individuals however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26577	\N	\N	\N	ANWAAR ALI MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26505	\N	\N	\N	SALMA KASSIM MOHAMMED	\N	1	Name flagged is MOHAMMED as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26506	\N	\N	\N	MOHAMED IBRAHIM MUHAMED	\N	1	Name flagged is MOHAMED as the sanctioned individual however its a common name since his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26507	\N	\N	\N	HODHAN MOHAMED FARAH	\N	1	Flagged due to the name MOHAMED FARAH however his other name rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26508	\N	\N	\N	MOHAMED SWALEH WENGO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26509	\N	\N	\N	KHAMIS HUSSEIN	\N	1	Name flagged is HUSSEIN same as the sanctioned individual however his other name KHAMIS and through EDD the above is not associated or related to the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26510	\N	\N	\N	MWALIMU ABDALLAH ALI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26511	\N	\N	\N	MOHAMED ABDI MIRE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26512	\N	\N	\N	SAID ABDULAZIZ SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26513	\N	\N	\N	ALBASHIR MOHAMED 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26514	\N	\N	\N	ABDIA ABDI OMAR	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26515	\N	\N	\N	ABDALLA ABUD	\N	1	Full name: Abdalla Abud Mohamed, ID no:13838732, DOB: 25.07.1976, Current loc: Kisauni mombasa. has no relation with the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26591	\N	\N	\N	REGINAH NYAMBURA NYAMBURA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26516	\N	\N	\N	MOHAMED JAFAR OMAR	\N	1	Full name: MOHAMED JAFFAR OMAR, UAE Resident ID: 784-1986-9157096-8, DOB: 30/05/1986, Current Loc: UAE, Nationality: KENYAN.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26517	\N	\N	\N	HUSSEIN OMARI RAI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26518	\N	\N	\N	SHAMSU MOHAMED MBARAK	\N	1	Name flagged is MOHAMED same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26519	\N	\N	\N	HASHIM SHEIKH MUHAMAD 	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26520	\N	\N	\N	ABDUL HAKIM\t	\N	1	Name: Abdulhakim Kambo Njoroge ID:28887164	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26521	\N	\N	\N	ABDUL HAKIM 	\N	1	Name:Abdulhakim Kambo Njoroge ID:28887164	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26522	\N	\N	\N	YUSUF HASSAN MWALIMU	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26523	\N	\N	\N	ABDILATIF ALI MOHAMED ABDILATIF	\N	1	Names not matching on ofac 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26524	\N	\N	\N	ZAINAB ABDULLA SWALEH	\N	1	Names dont match on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26525	\N	\N	\N	MOHAMED K  YUSSUF	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26526	\N	\N	\N	GIBSON RIUNGU	\N	1	Transaction was cancelled but reprocessed	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26527	\N	\N	\N	ABDALLAH ABDUL ABDALLAH	\N	1	Name flagged due to the common name ABDALLAH however his other names rules him out from the sanctioned individual from SYRIA.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26528	\N	\N	\N	DANIEL OUMA DANIEL OUMA	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26529	\N	\N	\N	GEORGE MBUCHI GEORGE MBUCHI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26530	\N	\N	\N	STEPHEN MARTIN BRIAN TOUS STEPHEN MARTIN BRIAN TOUS	\N	1	Name flagged due to the common name KHALIFA however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26531	\N	\N	\N	SUBEIDA MOHAMED  SULEMAN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26532	\N	\N	\N	HASHIM ADNAN	\N	1	Full name: Hashim Adnan Said Mohamed, DOB: 06.04.1974, National ID : 11873309, Nationality: Kenyan hence has no relation with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26533	\N	\N	\N	JAMAL MOHAMED 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26534	\N	\N	\N	HASSAN YUSUF	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26535	\N	\N	\N	KHALID MOHAMMED HAMTUT	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26536	\N	\N	\N	MOHAMED ABDULAHI	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26538	\N	\N	\N	ZAYANA ABDULLA KARIM	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26539	\N	\N	\N	MOHAMMED ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26540	\N	\N	\N	ESHAQ MOHAMED MUSA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26541	\N	\N	\N	 ABDULHAKIM AMIR 	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26542	\N	\N	\N	SHARMARKE MOHAMMED	\N	1	Name flagged is Mohammed however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26543	\N	\N	\N	SHAZIA ABDUL HAMID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26544	\N	\N	\N	MOHAMMED SAID MBARAK	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26545	\N	\N	\N	MUHAMMAD FAISAL	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26546	\N	\N	\N	ABDO MOHAMED ABDO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26547	\N	\N	\N	AHMAD MOHAMAD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26548	\N	\N	\N	HASSANI RIDHWANI MGUNYA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26549	\N	\N	\N	MOHAMED DAUD MOHAMUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26550	\N	\N	\N	SWABRI MOHAMED ABUD MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26551	\N	\N	\N	SAUMU MOHAMED HUSSEIN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26552	\N	\N	\N	ABDALLA SAID HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26553	\N	\N	\N	MWANAMAKA ABDUL ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26554	\N	\N	\N	AHMED HASSAN AHMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26555	\N	\N	\N	LUQMAN AHMED SWALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26556	\N	\N	\N	ABUBAKAR ABDALLAH	\N	1	Name flagged is Abdallah however is other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26557	\N	\N	\N	BRIDGIT MWIKALI PETER	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26558	\N	\N	\N	JUDY NJOGU	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26559	\N	\N	\N	KENNEDY ANDAYI AMAKABANE	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26560	\N	\N	\N	OMAR ABDULHALIM HASSAN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26561	\N	\N	\N	ZACHARY W KINGE	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26562	\N	\N	\N	ATSETSE BONFACE	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26563	\N	\N	\N	CECILIA KARURA	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26564	\N	\N	\N	MOHAMMED ADBUL RAHMAN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26565	\N	\N	\N	MUZINA ABDUL AZIZ	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26566	\N	\N	\N	HASHIM MOHAMED SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26567	\N	\N	\N	KHADIJA ABDULLA	\N	1	False Match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26568	\N	\N	\N	ALI JAFFAR	\N	1	False match due to the name Jaffar different from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26569	\N	\N	\N	MWANARUSI ABDALLAH RAMADHANI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26570	\N	\N	\N	SALIM IBRAHIM	\N	1	Name flagged due to the common name IBRAHIM however his other name rules him out from the sanctioned list.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26571	\N	\N	\N	SULEIMAN K MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26572	\N	\N	\N	HOUSE AND FARM COMPANY LIMITED	\N	1	Name flagged is LIMITED however the sanctioned name does not match or have relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26573	\N	\N	\N	IBRAHIM ABDALLAH	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26574	\N	\N	\N	KEN MWANGI	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26575	\N	\N	\N	ABDIKARIM MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26578	\N	\N	\N	NASIR MOHAMMAD	\N	1	Name flagged is MOHAMMED however his other name rules him out, since the sanctioned is a PEP.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26579	\N	\N	\N	SAID JUMA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26580	\N	\N	\N	JOSE PHINE MORAA N	\N	1	Name flaged JOSE same as the sanctioned individual from VENUZUELA who is a MALE yet our client is FEMALE, hence why no association.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26581	\N	\N	\N	BARKE ABDUL AZIZ	\N	1	Name flagged is ABDUL AZIZ same as the sanctioned however his other name BARKE rules him out, plus the sanctioned was arrested.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26582	\N	\N	\N	KENN MWANGI	\N	1	Name flagged is KENN while the sanctioned is KEN from KOREA however his other name MWANGI rules him out and location.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26583	\N	\N	\N	ABUBAKAR AHMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26584	\N	\N	\N	ALHADIY OMAR MOHAMED	\N	1	Name flagged due to the common name MOHAMED however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26585	\N	\N	\N	FAIZ ABUBAKAR MOHAMMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26586	\N	\N	\N	MOHAMED YUSUF MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26587	\N	\N	\N	HABIBA MOHAMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26588	\N	\N	\N	MOHAMED  ABDULAHI 	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26589	\N	\N	\N	NASRA ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26590	\N	\N	\N	AMANA MOHAMED OMAR	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26592	\N	\N	\N	RODGERS  OTIENO	\N	1	OKAY Client was double paid and funds were recovered 4/11/2019	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26593	\N	\N	\N	KHALID SAID HUSSEIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26594	\N	\N	\N	SULEIMAN MOHAMED YUSUF	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26595	\N	\N	\N	AHMED ADAN AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26596	\N	\N	\N	ABDULLAH YASSIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26597	\N	\N	\N	ABDUL RAHMAN AMAN MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26598	\N	\N	\N	SHARIFF ALI SHARIFF	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26599	\N	\N	\N	SAKWA SULEIMAN	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26600	\N	\N	\N	NAIMA KASSIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26601	\N	\N	\N	SAID ABDU MILINGO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26602	\N	\N	\N	DANIEL CHOME	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26603	\N	\N	\N	ALI KENYA ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26604	\N	\N	\N	ABDIA HUSSEIN ALIU	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26605	\N	\N	\N	AHMED FUAD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26606	\N	\N	\N	MOHAMED MUSA JUMA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26607	\N	\N	\N	SALIM HASSAN MWAKURIRIKANA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26608	\N	\N	\N	MOHAMED HASSANI OMAR\t	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26609	\N	\N	\N	FATMA SWALEH MOHAMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26610	\N	\N	\N	\N	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26611	\N	\N	\N	OMAR JAFFAR OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26612	\N	\N	\N	MOHAMED YAKHYA FALL	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26613	\N	\N	\N	OMAR YAHYA OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26614	\N	\N	\N	SALIM JAMAL SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26615	\N	\N	\N	MOHAMED OMAR JUMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26616	\N	\N	\N	MOHAMMED JUMBE SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26617	\N	\N	\N	SALIM JUMA ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26618	\N	\N	\N	MOHAMED SHEIKH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26619	\N	\N	\N	AHMAD ALI ADI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26620	\N	\N	\N	SWABRA OMAR MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26621	\N	\N	\N	MWINYIKHAMIS MUSA MOHAMMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26622	\N	\N	\N	AHMED SWALEH MBARAK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26623	\N	\N	\N	FATMA MOHAMMED NOOR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26624	\N	\N	\N	MARIAM MOHAMED MALIK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26625	\N	\N	\N	SAFIA AHMED ABDURAHMAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26626	\N	\N	\N	MEMA MOHAMED OMAR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26627	\N	\N	\N	SWALHA SALMIN SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26628	\N	\N	\N	SALIM SALMIN SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26629	\N	\N	\N	SIMEON SIMEON ONKWARE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26630	\N	\N	\N	MOHAMED ALI OMAR	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26631	\N	\N	\N	ABDULLAH JUMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26632	\N	\N	\N	MOHAMED MUSA ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26633	\N	\N	\N	NASSIM SWALEH ABDALLA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26634	\N	\N	\N	SALMA SALMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26635	\N	\N	\N	HASSAN OMARI ZANNY	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26636	\N	\N	\N	FAHIMA OMAR AWADH	\N	1	FAHIMA OMAR AWADH, 25008199, DOB 14/11/1985, LOC KENYA	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26637	\N	\N	\N	SIMON KASELI SIMON KASELI	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26638	\N	\N	\N	AZIZA MOHAMED ABUBAKAR	\N	1	Name flagged is Aziza same as the sanctioned individual however his other names rules him out from the sanctioned. NO ASSOCIATION TO THE SANCTIONED.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26639	\N	\N	\N	COLLIN OKADO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26640	\N	\N	\N	FAHAD JAMAL	\N	1	Name flagged due to the common name FaHAD howver his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26641	\N	\N	\N	NASSIR ABDALLAH MUHAMMAD SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26642	\N	\N	\N	KASSIM RASHID	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26643	\N	\N	\N	MOHAMED HUSSAIN ABDULLA	\N	1	Name flagged due to the common name MOHAMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26644	\N	\N	\N	HAMIDU ABDULKADIR ALI	\N	1	fALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26645	\N	\N	\N	FRED FRED	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26646	\N	\N	\N	ABDUL NOOR KALORY	\N	1	NAME FLAGGED IS NOOR HOWEVER HIS OTHER NAMES RULES HIM OUT FROM THE SANCTIONED INDIVIDUALS.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26647	\N	\N	\N	MOHAMED RAMADHAN MOHAMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26648	\N	\N	\N	NABILA HASSAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26649	\N	\N	\N	ALI ATHMAN	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26650	\N	\N	\N	HABIBA ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26651	\N	\N	\N	ABDILLAHI  ALI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26652	\N	\N	\N	SHAFFI AHMED SHAFFI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26653	\N	\N	\N	ABDUL AZIZ FAMAU NAGI	\N	1	Name flagged is AZIZ same as the sanctioned however other three names rules out from the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26654	\N	\N	\N	SHUMI SULEIMAN MOHAMMED	\N	1	False match due to the name MOHAMMED however other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26655	\N	\N	\N	HOUSE AND FARM  COMPANY LIMITED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26656	\N	\N	\N	WALID AMIN ALI	\N	1	Name flagged is ALI same as the sanctioned individual however his other names and location rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26657	\N	\N	\N	NURU ALI MOHAMED	\N	1	False on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26658	\N	\N	\N	FATUMA ALI	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26659	\N	\N	\N	MAJDA MOHAMED MBARAK	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26660	\N	\N	\N	MOHAMED SWALEH WENGO\t	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26661	\N	\N	\N	ALLAN FELIX	\N	1	Ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26662	\N	\N	\N	AMINA MOHAMED SALIM ABDALLA	\N	1	FALSE MATCH ON OFAC since the name flagged is MOHAMED same as the sanctioned individual who was arrested in 2003 hence has no relation.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26663	\N	\N	\N	HASSAN HAJJ	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26664	\N	\N	\N	SWAFIA MOHAMMED HAJJI	\N	1	Name flagged HAJJI same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26665	\N	\N	\N	AISHA MOHAMMED HASSAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26666	\N	\N	\N	MUSTAFA MOHAMED	\N	1	Full name: Mustafa Abdul Mohamed, DOB: 24/09/1983, UAE Resident Permit: 784-1983-5405872-3, Current loc: UAE, Nationality: Kenya.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26667	\N	\N	\N	HAMAD RASHID MOHEMD	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26668	\N	\N	\N	IBRAHIM SALIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26669	\N	\N	\N	SAID MOHAMMED ABUBAKAR	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26670	\N	\N	\N	FARAH MOHAMMAD HANIF	\N	1	Name flagged is MOHAMMAD same as the sanctioned individual however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26671	\N	\N	\N	HALIMA MOHAMED JUMA JUMA	\N	1	FALSE match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26672	\N	\N	\N	IDDI SHABAN SHABAN	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26673	\N	\N	\N	NURU MOHAMED	\N	1	Full name: Nuru Mohamed Ali Mwinzagu, DOB:14/10/1988, Kenyan Id: 26819437, Cur Loc: Mombasa. has no relation with the sanctioned individual.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26674	\N	\N	\N	JOYCE KAMENE KAMENE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26675	\N	\N	\N	MOHAMED YUSSUF SHEIK ADAN	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26676	\N	\N	\N	AHMED SALIM FARAD	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26677	\N	\N	\N	NASIM YUSUF	\N	1	Name flagged due to the name YUSUF however what rules her out from the sanctioned individual who are male.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26678	\N	\N	\N	KHALILA MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26679	\N	\N	\N	MOHAMED MOHAMED BWANAUSI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26680	\N	\N	\N	LEILA MOHAMMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26681	\N	\N	\N	MUSA MBARAKA MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26682	\N	\N	\N	AMANA MOHAMED OMAR 	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26683	\N	\N	\N	MUSA SHARIF MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26684	\N	\N	\N	MBARAKK SWALEH MBARAKK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26685	\N	\N	\N	HUSSEIN ALI	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26686	\N	\N	\N	JUMA SAID 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26687	\N	\N	\N	BILAL SAID MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26688	\N	\N	\N	SAUDA SAID MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26689	\N	\N	\N	HAMID MOHAME OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26690	\N	\N	\N	MOHAMUD AHMED FARAH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26691	\N	\N	\N	ASMA SAID HAMAD	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26692	\N	\N	\N	BARKE OMAR AWADH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26693	\N	\N	\N	ABDUL KARIM MAGOGO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26694	\N	\N	\N	AHMAD MASUD JUMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26695	\N	\N	\N	MOHAMED SULEIMAN MSELLAM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26696	\N	\N	\N	NGALA SALIM RASHID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26697	\N	\N	\N	ABDIKADIR MOHAMED FARAH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26698	\N	\N	\N	ABDALLA MOHMMED ABDALLA	\N	1	 NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26699	\N	\N	\N	LEILA OMAR MOHAMED	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26700	\N	\N	\N	ASMAA MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26701	\N	\N	\N	ALIO HASSAN ABDI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26702	\N	\N	\N	FATMA ABDALLAH MUHAMMAD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26703	\N	\N	\N	SAHARA SHEIKH IBRAHIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26704	\N	\N	\N	TIMA SALIM ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26705	\N	\N	\N	MOHAMED KENGA SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26706	\N	\N	\N	Harison karugu kimani	\N	1	Double paid client on 27/11/2019	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26707	\N	\N	\N	OMAR JAKU OMARI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26708	\N	\N	\N	JAMA ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26709	\N	\N	\N	HASSANI MOHAMED MWANDZOMBA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26710	\N	\N	\N	ABDULLA SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26711	\N	\N	\N	ABDI HASSAN AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26712	\N	\N	\N	AMIR SULEIMAN MOHAMED	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26713	\N	\N	\N	MOHAMMED SWALEH ATHUMAN	\N	1	Name flagged due to the common name MOHAMMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26714	\N	\N	\N	ABASI ABDUL MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26715	\N	\N	\N	ATSETSE BONFACE\t	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26716	\N	\N	\N	ABDUL AZIZ KHAMIS	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26717	\N	\N	\N	RAMADHAN MOHAMMED	\N	1	NAME FLAGGED IS MOHAMMED HOWEVER HIS OTHER NAME RULES HIM OUT FROM THE SANCTIONED INDIVIDUAL.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26718	\N	\N	\N	MARTHA CHEMUTAI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26719	\N	\N	\N	FARID ABUD BIN MOHAMED	\N	1	The individual sanctioned was arrested in 2002 for 30years hence why the beneficiary is not associated or differentiate him.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26720	\N	\N	\N	HASSAN ALI SHARIFF AHMAD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26721	\N	\N	\N	MOHAMED SULEMAN	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26722	\N	\N	\N	MARIAM ODINGA	\N	1	Name flagged is ODINGA same as the kenyan PEP surname however she has no relation to the PEP.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26723	\N	\N	\N	ASHA HASSAN ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26724	\N	\N	\N	NABILA MOHAMMAD AMIR	\N	1	Name flagged due to the common name MOHAMMAD however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26725	\N	\N	\N	NOOR ALI 	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26726	\N	\N	\N	WANYAMA NALIAKA CELESTINE /NACEWA CONSULTANCY	\N	1	ok.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26727	\N	\N	\N	MATANO HASSAN MOHAMMED	\N	1	Name flagged is Hassan same as the sanctioned however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26728	\N	\N	\N	SARAH JAMAL MAHAMUD MOHAMED	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26729	\N	\N	\N	JAMAL  MOHAMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26730	\N	\N	\N	HASSAN  YUSUF	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26731	\N	\N	\N	MOHAMMED ABBAS MUSA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26732	\N	\N	\N	HASSAN JUMA HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26733	\N	\N	\N	SALIM HASSAN BREK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26734	\N	\N	\N	OMAR MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26735	\N	\N	\N	SALAMA SALAMA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26736	\N	\N	\N	HAMID MOHAMED OMAR	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26737	\N	\N	\N	MESALIM SALIM BENDO	\N	1	Name flagged is SALIM same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26738	\N	\N	\N	AUSTINE NJOROGE NJOROGE	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26739	\N	\N	\N	ISA MAILH ABDUL AZIZ	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26740	\N	\N	\N	ANWAR AHMED MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26741	\N	\N	\N	OMAR KHATIB MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26742	\N	\N	\N	KHADIJA MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26743	\N	\N	\N	HASSAN MOHAMED ED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26744	\N	\N	\N	ZAYANA ABDULLA KARIM 	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26745	\N	\N	\N	SIYAD ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26746	\N	\N	\N	MUHAMME ALI ABDI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26747	\N	\N	\N	HAMIDA SALIM	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26748	\N	\N	\N	MOHAMED TWAHIR SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26749	\N	\N	\N	MWANATUMU SWALEH MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26750	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26751	\N	\N	\N	ALI AWATH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26752	\N	\N	\N	ABDUL RAHMAN AMAN MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26753	\N	\N	\N	ABDI MOHAMED ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26754	\N	\N	\N	MOHAMED YUSUF MWATETE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26755	\N	\N	\N	ABDUL FATAH TWAHIR	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26756	\N	\N	\N	SADA ABULLAH MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26757	\N	\N	\N	SHAMSA MOHAMED  IBRAHIM 	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26758	\N	\N	\N	SHAMSA MOHAMED  IBRAHIM	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26759	\N	\N	\N	OMAR AWAD H OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26760	\N	\N	\N	NUNDU ABDLLA MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26761	\N	\N	\N	ABDULRAHMAN MOHAMED ATHMANI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26762	\N	\N	\N	ABDULLAHI MOHAMMAD ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26763	\N	\N	\N	MBARAK MOHAMMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26764	\N	\N	\N	SALIM ATHMAN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26765	\N	\N	\N	KHATIJA MOHAMED HUSSEIN	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26766	\N	\N	\N	ABDULMALIK MOHAMED ABUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26767	\N	\N	\N	OMAR ABDUL REHMAN	\N	1	Not on OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26768	\N	\N	\N	ASAD AHMED AHMED BADAWY	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26769	\N	\N	\N	MARIA MAINA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26770	\N	\N	\N	ABDALLA ABDULHALIM MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26771	\N	\N	\N	MOHAMMED EBRAHIM MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26772	\N	\N	\N	MOHAMED SHARIFF OMAR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26773	\N	\N	\N	ZULFA KASSIM MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26774	\N	\N	\N	ALI RAJAB ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26775	\N	\N	\N	MOHAMED HABIB	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26776	\N	\N	\N	MOHAMED  HABIB	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26777	\N	\N	\N	MOHAMED ALI ABDULRAHMAN ALAMOODI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26778	\N	\N	\N	OMAR MOHAMED ALI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26779	\N	\N	\N	NAWAL OMAR MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26780	\N	\N	\N	MOHAMED ALI AHMED HUSSEIN OTHMAN	\N	1	NOT ON OFAC LIST	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26781	\N	\N	\N	NAGIB YAHYA MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26782	\N	\N	\N	SABRINA ABDUL RAHIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26783	\N	\N	\N	KASSIM ABUBAKAR AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26784	\N	\N	\N	MWANAKOMBO TWAHA HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26785	\N	\N	\N	ABDUL RAHMAN ALI ODOUR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26786	\N	\N	\N	ALWY ABDULRAHMAN AHMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26787	\N	\N	\N	SALMA OMAR MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26788	\N	\N	\N	AMINA HUSSAN OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26789	\N	\N	\N	HASSAN AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26790	\N	\N	\N	JAMIL ATHMAN	\N	1	OKAY NO Matching results on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26791	\N	\N	\N	JAMAL HASSAN	\N	1	Not on OFAc List	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26792	\N	\N	\N	THUREYA ABDUL HAMID	\N	1	NOT ON OFAC LIST 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26793	\N	\N	\N	ABBAS ABDULLA S TIRIMY	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26794	\N	\N	\N	SAYYID ABUBAKAR SHARIF	\N	1	NO matching results on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26795	\N	\N	\N	SAID MOHAMMED RAMADAN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26796	\N	\N	\N	SALIM MOHAMED ABDUL HADY	\N	1	Name flagged is MOHAMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26797	\N	\N	\N	MOHAMED SWALEH ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26798	\N	\N	\N	GRANTON MWAKULOMBA MWAKIO	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26799	\N	\N	\N	AMBASA LILIAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26800	\N	\N	\N	MOHAMED HUSSAIN  ABDULLA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26801	\N	\N	\N	ABDI MOHAMED NOOR	\N	1	FALSE ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26802	\N	\N	\N	MUHANDIS ABED	\N	1	NAME FLAGGED IS ABED HOWEVER THE NAME SANCTIONED IS ABD HENCE WHY NO ASSOCIATION OR RELATED.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26803	\N	\N	\N	EVANS INDEMBUKHANI  NASOLE	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26804	\N	\N	\N	VALENTINE  MUHONJA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26805	\N	\N	\N	MARTIN MUNDERU MAINA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26806	\N	\N	\N	SAADA MOHAMED AHMED	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26807	\N	\N	\N	SALIM HAMAD SIMBA	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26808	\N	\N	\N	ABEID ALI ABEID	\N	1	False match on OFAC the name flagged due to ABEID and the sanctioned individual is Abid hence no relation or association.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26809	\N	\N	\N	NOOR YASSIN NOOR	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26810	\N	\N	\N	FATUMA JAMA MOHAMED	\N	1	Name flagged is MOHAMED however her other names rules her out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26811	\N	\N	\N	ALI HUSSEIN ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26812	\N	\N	\N	MOHAMED SWALEH WENGO 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26813	\N	\N	\N	SWABRINA MOHAMMED SWALEH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26814	\N	\N	\N	AISHA MOHAMMED	\N	1	Name flagged is MOHAMMED same as the sanctioned individual however her other name rules her out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26815	\N	\N	\N	MASOUD HAJI MASOUD	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26817	\N	\N	\N	IBRAHIM MOHAMMED BAKHIT	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26818	\N	\N	\N	AMBASA LILIAN LILIAN	\N	1	FALSE match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26819	\N	\N	\N	HASSAN MOHAMED CHIBOHE	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26820	\N	\N	\N	ALBASHIR MOHAMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26821	\N	\N	\N	RIZIKI MOHAMMED SWALEH	\N	1	Name flagged is MOHAMMED same as the sanctioned individual however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26822	\N	\N	\N	IBRAHIM MOHAMMAD SHARIFF	\N	1	Name flagged is MOHAMMAD same as the sanctioned individual however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26823	\N	\N	\N	TERESA KAMBARA	\N	1	Name flagged is TERESA same as the sanctioned however her other names rules her out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26824	\N	\N	\N	ESHA SALIM	\N	1	Full name: Asha Said Salim, ID no:8620674, YOB: 1966, Current location: Mombasa. has no relation with the sanction individual who is male.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26825	\N	\N	\N	ABDULRAHMAN JAMAL ABDULRAHMAN	\N	1	Name flagged is ABDULRAHMAN same as the sanctioned individual however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26826	\N	\N	\N	ANDREW LANGAT	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26827	\N	\N	\N	NOOR ALI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26828	\N	\N	\N	HUSSEIN IBRAHIM  HASANOW	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26829	\N	\N	\N	ABDUL HAKIM	\N	1	Abdulhakim Kambo Njoroge; ID 28887164	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26830	\N	\N	\N	JOHN MARK WANDOLO	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26831	\N	\N	\N	MOHAMMED OMAR DAHMAN	\N	1	Name flagged due to the common name MOHAMMED however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26832	\N	\N	\N	KASSIM MOHAMED SAID	\N	1	Name flagged due to the common name Mohamed however his other names rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26833	\N	\N	\N	ALI ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26834	\N	\N	\N	NURA HASSAN ABDALLA	\N	1	False match	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26835	\N	\N	\N	MOHAMED KAKA	\N	1	FALSE MATCH	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26836	\N	\N	\N	SAID FARAJ SAID	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26837	\N	\N	\N	MAHMOUD YUSUF MOHAMED	\N	1	Name flagged due to the common name MOHAMED however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26838	\N	\N	\N	JUMA STAMBULI JUMA	\N	1	Name flagged due to the common name JUMA however his other names rules him out from the sanctioned who is a PEP in IRAQ.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26839	\N	\N	\N	HAMISI HAMISI GOZI	\N	1	FALSE MATCH ON OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26840	\N	\N	\N	HASSAN SHERIFF ABDALLA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26841	\N	\N	\N	OMAR MOHAMED BWANAOBO	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26842	\N	\N	\N	MOHAMED OMAR KARAMA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26843	\N	\N	\N	ELIZABETH KAHONZI CHARO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26844	\N	\N	\N	HAMISI RASHID HAMISI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26845	\N	\N	\N	NAILA SWALEH	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26846	\N	\N	\N	FAIZA ABDALLA MOHAMED	\N	1	Not found on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26847	\N	\N	\N	SALIMU SAID MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26848	\N	\N	\N	JOHN MUMBI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26849	\N	\N	\N	FATMA MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26851	\N	\N	\N	SHARIFA OMAR MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26852	\N	\N	\N	ASLI ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26853	\N	\N	\N	HABIBA RASHID SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26854	\N	\N	\N	ADAM ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26855	\N	\N	\N	HASHIM MOHEMAD	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26856	\N	\N	\N	MOMO OMAR MOHAMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26857	\N	\N	\N	HASSAN ABDALLA SALIM	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26858	\N	\N	\N	JAMES NJOROGE KARANJA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26859	\N	\N	\N	JOHN MARK OKONDO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26860	\N	\N	\N	SHAMSA MOHAMED IBRAHIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26861	\N	\N	\N	MOHAMMED KHALID SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26862	\N	\N	\N	SAID ABDURAHMAN SHEIKH SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26863	\N	\N	\N	WAHAB ABDU MUHAMMEDD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26864	\N	\N	\N	HASSAN RASHID IBRAHIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26865	\N	\N	\N	LEILA MOHAMED ABDULLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26866	\N	\N	\N	AHMED ABDALLAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26867	\N	\N	\N	MAHAMED HUSSIEN MUMIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26868	\N	\N	\N	JAMAL MOHAMED ABDI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26869	\N	\N	\N	ADAM YAHYA ADAM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26870	\N	\N	\N	UMAR HASSAN	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26871	\N	\N	\N	JAMILA MOHAMED	\N	1	Name not in the sanction list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26872	\N	\N	\N	JANE WANDIA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26873	\N	\N	\N	YVONNE ACHIENG OCHIENG	\N	1	False match on OFAC.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26874	\N	\N	\N	HASSAN SALIM	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26875	\N	\N	\N	ALIA AHMED SHEIKH OMAR	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26876	\N	\N	\N	SWALEH ABDALLA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26877	\N	\N	\N	SWALEH  ABDALLA	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26878	\N	\N	\N	HABIBA MOHAMMAD  AHMED	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26879	\N	\N	\N	ESHA AHMED ABDULLAH	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26880	\N	\N	\N	ALI SUDI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26881	\N	\N	\N	LUTHER MARI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26882	\N	\N	\N	KHALI ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26883	\N	\N	\N	ALI ATHMAN ALI	\N	1	AML VERIFICATION FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26884	\N	\N	\N	NABILA MOHAMMED SAID	\N	1	Name flagged is Nabila however his other names rules him out from the sanctioned individuals.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26885	\N	\N	\N	IBRAHIM AMIR	\N	1	The sanctioned individual is a PEP.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26886	\N	\N	\N	KHALI ALI 	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26887	\N	\N	\N	BASHIR HASSAN	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26888	\N	\N	\N	ADHAN MOHAMMED	\N	1	Full name: ADHAN MOHAMMED AHMED, Kenyan ID no:36638823, DOB: 05.04.1998, Current Location: Nairobi Kenya, Residences in Narok. MALE. hence has no relation to the sanctioned individual from IRAQ.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26890	\N	\N	\N	KIMWANA ABDALLA ABDALLA	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26893	\N	\N	\N	HAWA ABDIRAHMAN	\N	1	Name flagged is ABDIRAHMAN same as the sanctioned however what rules him out is his other name HAWA.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26894	\N	\N	\N	SAID MOHAMMED BAZUMA	\N	1	Name flagged SAID MOHAMMED same as the sanctioned individual however his other name rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26896	\N	\N	\N	ABDUL JABBAR ABDALLAH	\N	1	Name flagged ABDUL JABBAR same as the sanctioned individual however his other name rules him out.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26897	\N	\N	\N	HAMISI  ALI	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26898	\N	\N	\N	AMOS KAMUI KAMUI	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26899	\N	\N	\N	AWADH SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26900	\N	\N	\N	YAHYA MOHAMED ALI MAHADI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26901	\N	\N	\N	HUSSEIN IBRAHIM HASANOW	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26902	\N	\N	\N	OMAR MOHAMED ABUSHIRI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26903	\N	\N	\N	OMAR HUSSEIN IBRAHIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26904	\N	\N	\N	MOHAMED K YUSSUF	\N	1	Name flagged due to the common name MOHAMED however his other name rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26905	\N	\N	\N	AMAR ALI	\N	1	False Match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26906	\N	\N	\N	SALMA ABDALLH	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26907	\N	\N	\N	MAALIM ADI MAALIM	\N	1	OK	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26908	\N	\N	\N	FAHMI KHALIFA ABUBAKAR	\N	1	Name flagged due to the common name KHALIFA however his other names rules him out from the sanctioned.	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26909	\N	\N	\N	YUSUF HASSAN YUSUF	\N	1	FALSE MATCH ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26910	\N	\N	\N	ABSHIRO ABDULLAHI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26911	\N	\N	\N	MARK JOHN NGOLO	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26912	\N	\N	\N	ALI ALI KILALO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26913	\N	\N	\N	SAID ABDU PONDA	\N	1	NOTON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26914	\N	\N	\N	RODGERS OTIENO 	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26915	\N	\N	\N	ABDULMANAF ABUBAKAR AHAMED	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26916	\N	\N	\N	KUSOW MOHAMED IBRAHIM	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26917	\N	\N	\N	ABDULL AZIZ	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26918	\N	\N	\N	HASSAN MOHAMED NDERITU	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26919	\N	\N	\N	ABDALLA MWINYIHAJI ABDULLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26920	\N	\N	\N	MUHAMMAD SAID JUMAAN AWADH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26921	\N	\N	\N	BURHAN AHMED YASIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26922	\N	\N	\N	MWARI ABDUL ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26923	\N	\N	\N	ABDUL RAHMAN BUNU SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26924	\N	\N	\N	KIBIBI MOHAMMED AMRAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26925	\N	\N	\N	LATIFA ABDU AWADH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26926	\N	\N	\N	FAIZA MOHAMED SULTAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26927	\N	\N	\N	HAJI SALIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26928	\N	\N	\N	KINGI OMARI KINGI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26929	\N	\N	\N	RASHIDAH RASHIDAH	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26930	\N	\N	\N	KASSIM ABDUL MWINYI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26931	\N	\N	\N	SALIM SAID SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26932	\N	\N	\N	MOHAMED JAHID	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26933	\N	\N	\N	IMAN ABDULKADER HUSSEIN	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26934	\N	\N	\N	NAJAT MOHAMED ABDUL AZIZ	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26935	\N	\N	\N	ABDALLA ABDALLA MUHAMMAD	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26936	\N	\N	\N	BILAL ADAN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26937	\N	\N	\N	OMAR MOHAMMED KAZUNGU	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26938	\N	\N	\N	KASSIM AHMED MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26939	\N	\N	\N	ALAMIN ALAMIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26940	\N	\N	\N	SAID ABBAS ABDALLA	\N	1	No False result on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26941	\N	\N	\N	SALIMA MOHAMMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26942	\N	\N	\N	ASHA SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26943	\N	\N	\N	ASMAA MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26944	\N	\N	\N	ABDURAHMAN MOHAMED AMIR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26945	\N	\N	\N	BINTI HAMISI HAMISI GUMBO\t	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26946	\N	\N	\N	MWANAHAMISI JUMA JUMA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26947	\N	\N	\N	ABDULLAH ANWAR	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26948	\N	\N	\N	MOHAMMED SHEE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26949	\N	\N	\N	MOHAMMAD ABDALLAH MATSUDZO	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26950	\N	\N	\N	NABILA MOHAMMED AMER	\N	1	Not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26951	\N	\N	\N	FAIZA ALI MOHAMED	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26952	\N	\N	\N	SHAMSO MOHAMED FARAH	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26953	\N	\N	\N	KUNGALA JUMA JUMA	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26954	\N	\N	\N	MOHAMMED ABUD	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26955	\N	\N	\N	ELIYE MOHAMED OMAR	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26956	\N	\N	\N	PAULINE PAULINE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26957	\N	\N	\N	MISHI HAMISI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26958	\N	\N	\N	HUSSEIN ABUBAKAR HUSSEIN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26959	\N	\N	\N	KASSIM MOHAMED	\N	1	NO MATCHING RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26960	\N	\N	\N	ALAWI ABDUL SWAMAD	\N	1	No matching results on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26961	\N	\N	\N	OMAR ABDULLAH OMAR	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26962	\N	\N	\N	HABIBA ABDI MOHAMMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26963	\N	\N	\N	AHMED YUSUF	\N	1	Not on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26964	\N	\N	\N	SAMYA YUSUF HASSAN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26965	\N	\N	\N	DAHIR HASSAN SIYAD	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26966	\N	\N	\N	MOHAMED YUSUF MAKAME	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26967	\N	\N	\N	YASMIN MOHAMED SHAFIK	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26968	\N	\N	\N	SALIM MOHAMED SALIM	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26973	\N	\N	\N	NJAMI NJAMBI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26974	\N	\N	\N	SAMSON KIRWA CHIR CHIR	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26975	\N	\N	\N	PATRICK THUO	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26976	\N	\N	\N	HAMADI ABDALLA MASUDI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26977	\N	\N	\N	OMAR MOHAMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26978	\N	\N	\N	JUMA JUMA MWATARI	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26979	\N	\N	\N	NASRA SALIM HASSAN	\N	1	AML FAILURE	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26980	\N	\N	\N	KHADIJA OMAR HUSSEIN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26981	\N	\N	\N	MOHAMED AHMED MOHAMED ADAM	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26982	\N	\N	\N	RAMLA SHARIFF AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26983	\N	\N	\N	YUSSUF AL HASSAN	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26984	\N	\N	\N	SAID ABOUD MUHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26985	\N	\N	\N	AMRIK  SINGH CHANNA CHANNA	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26986	\N	\N	\N	MOHAMMED MOHAMED DUMILA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26987	\N	\N	\N	AHMED MOHAMMED ABDURAHMAN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26988	\N	\N	\N	ABDALLA MUSA ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26989	\N	\N	\N	MWANAHASSAN OMAR HASSAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26990	\N	\N	\N	ABDALLA SALEH HADI	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26991	\N	\N	\N	MWANAHALIMA ABDUL RAHMAN ALI	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26992	\N	\N	\N	MOHAMED JAMA MURSAL	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26993	\N	\N	\N	LATWIFA ABDUL KADIR ABOUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26995	\N	\N	\N	SEBI IBRAHIM HASSAN	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26996	\N	\N	\N	SAMI SAYID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26997	\N	\N	\N	ALWI AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26998	\N	\N	\N	HASSAN OMAR HASSAN MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	26999	\N	\N	\N	SALIM ALI ABDUL RAHMAN	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27000	\N	\N	\N	SALMA KASSIM	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27001	\N	\N	\N	ABDULLAHI BASHIR ALI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27002	\N	\N	\N	ABID HAFIDH MALAK MOHAMED	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27003	\N	\N	\N	ASHA ABDALLAH HASSAN ELKINDY	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27004	\N	\N	\N	ZUBEDA MUSTAFA ABDALLA	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27005	\N	\N	\N	STEVE LTUMBESI  LELEGWE	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27006	\N	\N	\N	TIMA AHMED KHALFAN	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27007	\N	\N	\N	AHMED HASSAN ABDALLA ALLUI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27008	\N	\N	\N	MOHAMED FARAH ABDI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27009	\N	\N	\N	RUKHSANA MOHAMED HUSSEIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27010	\N	\N	\N	ABID ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27011	\N	\N	\N	SAID MOHAMED FAMAU	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27012	\N	\N	\N	KIBWAWA MOHAMMED SHAFI	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27013	\N	\N	\N	MAUREEN ACHIENG OCHIENG	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27014	\N	\N	\N	FAIZA MOHAMMED OMAR	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27015	\N	\N	\N	ALI HATIBU HAJI\t	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27016	\N	\N	\N	AHMED ALI HAMED TINAI	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27017	\N	\N	\N	KHADIJA OMAR HASSAN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27018	\N	\N	\N	JAMAL MOHAMED GUYO	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27019	\N	\N	\N	RASHID ISSA RASHID MWAJITA	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27020	\N	\N	\N	HABIBA MALIK	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27021	\N	\N	\N	NAJMA MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27022	\N	\N	\N	ALI AHMED MAALIM	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27023	\N	\N	\N	ASWIL MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27024	\N	\N	\N	ARIF GULAM MOHAMMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27025	\N	\N	\N	NURU MOHAMED SAID TAMIM	\N	1	Not on ofac List 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27026	\N	\N	\N	MOHAMED OMARI SILEIMAN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27027	\N	\N	\N	MOHAMED ATHUMAN MOHAMED	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27028	\N	\N	\N	MUSA SIMKIWA MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27029	\N	\N	\N	JOSEPHAT MAINA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27030	\N	\N	\N	SAUDA SAID	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27031	\N	\N	\N	ENZULA AZIZA ABDUL	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27032	\N	\N	\N	MAURINE MUSENGYA DANIEL	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27033	\N	\N	\N	FAHD SAID MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27034	\N	\N	\N	HASSAN MWIDADI HASSAN	\N	1	NOT ON  OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27035	\N	\N	\N	MARYAM HASSAN ABDALLA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27036	\N	\N	\N	ALEC NDOLO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27037	\N	\N	\N	MOHAMED IBRAHIM ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27038	\N	\N	\N	MOHAMMED YUSUF	\N	1	not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27039	\N	\N	\N	YASSIM MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27040	\N	\N	\N	ABDILLAHI ABDALLAH	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27041	\N	\N	\N	AHADI IBRAHIM WAKHUNGU	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27042	\N	\N	\N	HASSAN MOHAMED HASSAN	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27043	\N	\N	\N	JUDITH ACHIENG OCHIENG	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27044	\N	\N	\N	RESHMA AMIR KHAN KAYAM KHAN 	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27045	\N	\N	\N	HASSANI SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27046	\N	\N	\N	MOHAMED HUSSEIN MUMIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27047	\N	\N	\N	HASAN ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27048	\N	\N	\N	SALMA HASSAN MAHAMOUD	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27049	\N	\N	\N	MOHAMMED MOHAMMED KWEYU	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27050	\N	\N	\N	AHMED ABDULRAHMAN AHMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27051	\N	\N	\N	HASSAN MOHAMED ALI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27052	\N	\N	\N	JABU BABU ALI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27053	\N	\N	\N	SAID MOHAMED SAID	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27054	\N	\N	\N	SABIHA MOHAMED ISMAIL	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27055	\N	\N	\N	MAHMOUD MOHAMMAD ALAMIN MUHSIN	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27056	\N	\N	\N	FERDOS ABUD AHMED 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27057	\N	\N	\N	MOSES NJOROGE KARANJA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27058	\N	\N	\N	FAUZ MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27059	\N	\N	\N	MOHAMMAD ABDULAZIZ IDHA	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27060	\N	\N	\N	MOHAMED SULIEMAN EGE	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27061	\N	\N	\N	IBRAHIMA SARR	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27062	\N	\N	\N	ISSA ABDILLAHI MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27063	\N	\N	\N	AMINA MOHAMMED ABDALLAH	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27064	\N	\N	\N	MWAKA MOHAMED ISSA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27065	\N	\N	\N	HUSSEIN ABDULGAN HUSSEIN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27066	\N	\N	\N	ABDUL RAZAK MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27067	\N	\N	\N	MOHAMED OMAR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27068	\N	\N	\N	AFANDE BRIGHT BRIGHT	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27069	\N	\N	\N	JIMIA SULEIMAN SULEIMAN	\N	1	nOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27070	\N	\N	\N	<STEVE LTUMBESI LELEGWE~KEN~KES~ 	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27071	\N	\N	\N	IBRAHIM RASHID ALIO	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27072	\N	\N	\N	YASMIN  MOHAMED  SHAFIK	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27073	\N	\N	\N	HUSSEIN OMAR HUSSEIN	\N	1	Fase results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27074	\N	\N	\N	FATHIYA MOHAMMED MUSA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27075	\N	\N	\N	MUNIRA MUNIR ABDALLAH	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27076	\N	\N	\N	HUSSEIN ADAM HUSSEIN	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27077	\N	\N	\N	ASHA ASMAN YUSUF	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27078	\N	\N	\N	ABDULLAH KASIM	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27079	\N	\N	\N	SALAMA SAID MOHAMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27080	\N	\N	\N	AISHA MOHAMED MUHAJI OMAR	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27081	\N	\N	\N	ABDUL AHMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27082	\N	\N	\N	AMINA MOHAMMED MWALIMU	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27083	\N	\N	\N	SEIF ABDALLAH SEIF	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27084	\N	\N	\N	ZAMZAM OMAR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27085	\N	\N	\N	ABDALLAH YUSUF ABDULRAZAK SHEIKH	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27086	\N	\N	\N	HUSSEIN ABDUL	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27087	\N	\N	\N	HASSAN MOHAMMED MAKAME	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27088	\N	\N	\N	HASSAN ABDALLA HASSAN	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27089	\N	\N	\N	ABDUL RAHIM KARAMAE	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27090	\N	\N	\N	ALI YUSUF ALI GONDA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27091	\N	\N	\N	AMRIK SINGH CHANNA CHANNA  	\N	1	No matching results on opfac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27092	\N	\N	\N	ABDALLAH HAMAD ABDALLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27093	\N	\N	\N	Eleshia Ronge	\N	1	Not on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27094	\N	\N	\N	YUSSUF ALI SALIM	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27095	\N	\N	\N	ARNOLD MWENDIA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27096	\N	\N	\N	MOHAMED YUSSUF SHEIKH	\N	1	No matching results on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27097	\N	\N	\N	MOHAMED SAID  CHOCHOTE\t	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27098	\N	\N	\N	RESHMA AMIR KHAN KAYAM KHAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27099	\N	\N	\N	MOHAMUD MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27100	\N	\N	\N	ALI HAROUB ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27101	\N	\N	\N	KASSIM FARUK MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27102	\N	\N	\N	SULEIMAN OMAR MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27103	\N	\N	\N	MOHAMED MBWANA EBRAHIM	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27104	\N	\N	\N	FERDOS ABUD AHMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27105	\N	\N	\N	FERDOS ABUD AHMED   	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27106	\N	\N	\N	AWADHI JAMAL AWADHI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27107	\N	\N	\N	MARYAM OMAR MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27108	\N	\N	\N	ABDULRAHMAN MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27109	\N	\N	\N	BAKARI HAMISI BAKARI	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27110	\N	\N	\N	RASHID SHIDE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27111	\N	\N	\N	MOHAMED HASHI MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27112	\N	\N	\N	RAHIMA ABDALLA ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27113	\N	\N	\N	ABDUL RAHMAN SHEE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27114	\N	\N	\N	MICHAEL KIBUNJA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27115	\N	\N	\N	AHMED MUHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27116	\N	\N	\N	SULEMAN NOOR MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27117	\N	\N	\N	FARUTUNI MOHAMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27118	\N	\N	\N	RUKHSANA MOHAMED  HUSSEIN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27119	\N	\N	\N	SALIM BOKIA SALIM	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27120	\N	\N	\N	MOHAMUD AMIN	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27121	\N	\N	\N	FATMA MOHAMED SWALIHU	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27122	\N	\N	\N	SYNAB OMAR MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27123	\N	\N	\N	SAID MKUZI MOHAMMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27124	\N	\N	\N	ABDALLA AHMED ABDALLA	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27125	\N	\N	\N	AHMED SABIR TAHIR SHEIKH SAID\t	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27126	\N	\N	\N	REHEMA ABDULLA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27127	\N	\N	\N	MOHAMED SWALEH ABDALLA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27128	\N	\N	\N	ABDULHAMID ABUBAKAR ABDULHAMID	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27129	\N	\N	\N	SALIM SIMBA RASHID	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27130	\N	\N	\N	MWANAHAMISI MOHAMMED OMAR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27131	\N	\N	\N	AMRIK SINGH CHANNA CHANNA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27132	\N	\N	\N	HASSAN ABDALLA AHMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27133	\N	\N	\N	ASWIL MOHAMED ALI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27134	\N	\N	\N	MOHAMED SAID CHOCHOTE	\N	1	No matching results on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27135	\N	\N	\N	SAIDA HASSAN MOHAMED	\N	1	No Matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27136	\N	\N	\N	BARAKA MOHAMMAD YUSUF	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27137	\N	\N	\N	JOHN PAUL OYILE AMOLLO	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27138	\N	\N	\N	WAZIR KHAMIS WAZIR	\N	1	No matching results on Ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27139	\N	\N	\N	RESHMA AMIR  KHAN KAYAM KHAN	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27140	\N	\N	\N	ABDILLE MOHAMUD	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27141	\N	\N	\N	NURU MOHAMED DORCAS	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27142	\N	\N	\N	NURU  MOHAMED  DORCAS	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27143	\N	\N	\N	VERONICA MORAO ALBERT	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27144	\N	\N	\N	IBRAHIM SALIM ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27148	\N	\N	\N	MUZINA ABDULL AZIZ	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27149	\N	\N	\N	ALI ALI NAGRE	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27150	\N	\N	\N	AMINA BASHIR	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27151	\N	\N	\N	HALIMA MOHAMMAD	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27152	\N	\N	\N	ABDULLA ALI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27154	\N	\N	\N	RAHIMA ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27155	\N	\N	\N	ALI SWALEH MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27156	\N	\N	\N	FAWZIA MOHAMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27157	\N	\N	\N	MUSTAFA ABDUL	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27158	\N	\N	\N	YASMIN MOHAMED  SHAFIK	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27159	\N	\N	\N	MOHAMED YUSUF	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27161	\N	\N	\N	HILAL AMOR HILAL	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27162	\N	\N	\N	OMAR HAMISI MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27163	\N	\N	\N	JIBU SAID MOHAMED	\N	1	no matching rsults on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27164	\N	\N	\N	SAID MUHAMMAD SAID	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27165	\N	\N	\N	ALI HATIBU HAJI	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27166	\N	\N	\N	MOHAMED KHAMISI SULEIMAN\t	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27167	\N	\N	\N	HAMADI HAMADI MWACHOTEA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27168	\N	\N	\N	MOHAMMED SAID BAIKI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27169	\N	\N	\N	OMARI MOHAMED	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27170	\N	\N	\N	MARION CAROL MUTEMA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27171	\N	\N	\N	MOHAMED HARITH MOHAMED	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27172	\N	\N	\N	ASHA MOHAMED ALI	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27173	\N	\N	\N	MOHAMMED SAID REHEMTULA	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27174	\N	\N	\N	OMAR MOHAMED GODHANA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27175	\N	\N	\N	FATMA ABDILLAHI AHMED	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27176	\N	\N	\N	HASSAN ABDULLATIF SALIM	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27177	\N	\N	\N	MOHAMMED HUSSEIN MOHAMMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27178	\N	\N	\N	ZED AHMAD SAID	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27179	\N	\N	\N	KHALID MOHAMED HAMTUT	\N	1	Not on ofac 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27180	\N	\N	\N	AHMED IBRAHIM AHMED DADA	\N	1	Not on ofac list	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27181	\N	\N	\N	ABDUL HAKIM SOMOBWA MAALIM	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27182	\N	\N	\N	LALI MOHAMED LALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27183	\N	\N	\N	SEBI IBRAHIM HASSANE	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27184	\N	\N	\N	IMTYAZ GULAM KHAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27185	\N	\N	\N	MOHAMED ABDI ALI	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27186	\N	\N	\N	MOHAMED SAID CHOCHOTE    	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27187	\N	\N	\N	ZAHIRA  KHAN 	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27188	\N	\N	\N	SALMA MOHAMED ABDULLA	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27189	\N	\N	\N	HAMIDA AHMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27190	\N	\N	\N	HASSAN MOHAMED MBARAK	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27191	\N	\N	\N	SHAMSO MOHAMED FARAH\t	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27192	\N	\N	\N	RIYADH MOHAMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27193	\N	\N	\N	ABBAS MOHAMMED	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27194	\N	\N	\N	JOHN PAUL ONYANGO OMOTH	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27195	\N	\N	\N	FATIMA FADHIL MOHAMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27196	\N	\N	\N	ALI YASIN	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27197	\N	\N	\N	FAUZIA MOHAMMAD SALIM	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27198	\N	\N	\N	MOHAMED HASSAN YESLAM	\N	1	False result on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27199	\N	\N	\N	SHARIFA YUSUF SHARIFF	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27200	\N	\N	\N	HASSAN MOHAMED RASHID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27201	\N	\N	\N	MOHAMED KHAMIS SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27202	\N	\N	\N	MOHAMMED BAKARI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27203	\N	\N	\N	SILVIA SILVIA	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27204	\N	\N	\N	ESHA MUHAMMED OMAR	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27205	\N	\N	\N	FATUMA IBRAHIM SULEIMAN	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27206	\N	\N	\N	Abdulrahman hassan Abdulrahman	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27207	\N	\N	\N	RUKHSANA MOHAMED HUSSEIN\t	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27208	\N	\N	\N	SAID MOHAMED MASERA	\N	1	no matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27210	\N	\N	\N	IBRAHIM ABDULAZIZ MUSTAFA	\N	1	FALSE RESLTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27211	\N	\N	\N	MOHAMED SWALEH MOHAMED	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27212	\N	\N	\N	YUSSUF MUHAMED ALI	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27213	\N	\N	\N	MOHAMED TAHER	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27214	\N	\N	\N	ABDALLAH RAMADHAN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27215	\N	\N	\N	SWALEH OMAR HUSSEIN	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27216	\N	\N	\N	BARAKAT MOHAMMED BAALAWY	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27217	\N	\N	\N	MANSOOR ABDUL AZIZ AHMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27218	\N	\N	\N	AHMED SABIR TAHIR SHEIKH SAID	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27219	\N	\N	\N	YUSRA MOHAMMAD OMAR TAJIR	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27220	\N	\N	\N	IDRIS MOHAMED HUSSEIN ABSURA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27221	\N	\N	\N	MUNIR MUNIR	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27222	\N	\N	\N	MARIAM MOHAMED SAID	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27223	\N	\N	\N	SAFIA ABDULLA SWALEH	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27224	\N	\N	\N	MUSA MUHAMMED MWABOMA	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27225	\N	\N	\N	SALIM AYUB SALIM	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27226	\N	\N	\N	ABDULKARIM MAHADHI ABDULKARIM	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27227	\N	\N	\N	Mohamed Abdi Ali	\N	1	False results	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27228	\N	\N	\N	AMRIK SINGH CHANNA  CHANNA	\N	1	Ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27229	\N	\N	\N	ZAHRA MOHAMMAD AMIN	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27230	\N	\N	\N	MOHAMED MOHAMED DUMILA	\N	1	false results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27232	\N	\N	\N	MOHAMMED MOHAMMED ABDUL MALIK	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27233	\N	\N	\N	MOHAMED MUHUMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27234	\N	\N	\N	PATRICK MUIGAI PATRICK MUIGAI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27235	\N	\N	\N	\N	\N	1	\N	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27236	\N	\N	\N	MOHAMED JAMA  MURSAL	\N	1	ok	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27237	\N	\N	\N	EUTYCHUS JOSEPH JOSEPH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27238	\N	\N	\N	SHAMSO FARAH	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27239	\N	\N	\N	THABIT MUHAMMAD ABDALLA NASHER	\N	1	False match on OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27240	\N	\N	\N	SAID MOHAMED SULEIMAN	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27241	\N	\N	\N	SALIM ALI MOHAMMED	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27242	\N	\N	\N	YUSUF MOHAMED ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27243	\N	\N	\N	MOULID MOHAMED MOHAMUD	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27244	\N	\N	\N	MOHAMMED IBRAHIM DIAB	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27245	\N	\N	\N	MAHAMOUD HASSAN ROBLEH	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27246	\N	\N	\N	RASHID MOHAMED RASHID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27247	\N	\N	\N	YASSIR ALI	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27248	\N	\N	\N	SEIF IDD SEIF	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27250	\N	\N	\N	MOHAMED KHAMISI SULEIMAN	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27251	\N	\N	\N	QAIS MOHAMMED	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27252	\N	\N	\N	ABDUL MALIK ABDALLA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27253	\N	\N	\N	ABDULL KADIR HUSSEIN ABDALLA	\N	1	False results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27254	\N	\N	\N	ABDULRAHMANI AMANI MOHAMED	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27255	\N	\N	\N	HADJA ALI	\N	1	OKAY	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27256	\N	\N	\N	JUMA ABDUL MWANZINGA	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27257	\N	\N	\N	ALI RAMA	\N	1	okay	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27258	\N	\N	\N	FRANCIS FRANCIS OKUMU	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27259	\N	\N	\N	ALI ABUBAKAR AHMED	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27260	\N	\N	\N	AHMED MUSTAFA	\N	1	not on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27261	\N	\N	\N	UMI ABDUL JUMA	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27262	\N	\N	\N	SHAFI IBRAHIM SULEIMAN	\N	1	Not on ofac list 	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27263	\N	\N	\N	MUHAMMAD MBARAK SALIM	\N	1	FALSE RESULTS ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27264	\N	\N	\N	MOHAMMAED YUSUF MWAMZANDI	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27265	\N	\N	\N	SWAFIYA MOHAMED SAID	\N	1	NOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27266	\N	\N	\N	ISSA MOHAMED ALII	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27267	\N	\N	\N	SHAABAN ABDULAZIZ SHAABAN	\N	1	BOT ON OFAC	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27268	\N	\N	\N	SWALEH MOHAMED KHAMIS	\N	1	No matching results on ofac	\N	\N	f	0	2020-04-03 10:15:16.212107+03	\N	\N	0	\N
1588163697	2	\N	2	\N	\N	27269	\N	\N	\N	\N	\N	\N	\N	blacklist.xlsx	\N	t	0	2020-04-29 15:34:57.150473+03	\N	\N	0	\N
1588163726	2	\N	2	\N	\N	27270	\N	\N	\N	\N	\N	\N	\N	blacklist.xlsx	\N	t	0	2020-04-29 15:35:26.984057+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27271	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:49:59.184192+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27272	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:51:11.17547+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27273	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:52:37.353839+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27274	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:55:08.314697+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27275	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:56:26.777349+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27276	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:57:26.206256+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27277	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 10:59:45.932642+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27278	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 11:00:11.121708+03	\N	blacklist.xlsx	0	0
\N	\N	\N	\N	\N	\N	27279	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 11:03:28.168326+03	\N	blacklist.xlsx	0	0
1588235138	2	\N	2	\N	\N	27280	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 11:25:38.547657+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27281	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 12:47:37.531553+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Carol Gitonga",25425016268,4526784,null],["Mark Waweru",25425016267,238401,null]]
\N	\N	\N	\N	\N	\N	27282	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:01:57.189634+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Carol Gitonga",25425016268,4526784,null],["Mark Waweru",25425016267,238401,null]]
\N	\N	\N	\N	\N	\N	27283	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:21:00.435286+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Carol Gitonga",25425016268,4526784,null],["Mark Waweru",25425016267,238401,null]]
\N	\N	\N	\N	\N	\N	27284	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 13:28:45.038866+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27285	\N	4526784	\N	Carol Gitonga	25425016268	\N	\N	\N	\N	t	0	2020-04-30 13:28:45.078718+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27286	\N	238401	\N	Mark Waweru	25425016267	\N	\N	\N	\N	t	0	2020-04-30 13:28:45.082465+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27287	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:38:27.185018+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27288	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:39:13.992927+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27289	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:41:02.510186+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27290	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:42:35.46901+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27291	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:43:11.436285+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27292	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:44:00.382937+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27293	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:44:35.398767+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27294	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:44:53.434375+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27295	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:45:07.025564+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27296	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:45:43.267592+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27297	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:46:02.966603+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27298	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:47:50.776115+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27299	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:49:06.057381+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27300	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:49:50.647045+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27301	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 13:50:30.261363+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27302	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 14:06:31.464473+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27303	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 14:06:31.466197+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27304	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 14:06:31.467241+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27305	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 14:07:17.89525+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27306	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:07:20.822675+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27307	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:07:20.830589+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27308	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:07:20.83171+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27309	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 14:08:37.344463+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27310	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 14:09:08.970865+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27311	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:09:12.265391+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27312	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:09:12.267191+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27313	\N	customer_name	\N	customer_name	customer_name	\N	\N	\N	\N	t	0	2020-04-30 14:09:12.268342+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27314	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 14:10:20.60184+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27315	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 14:13:39.980592+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27316	\N	64529784	\N	Milkah Warui	25425016568	\N	\N	\N	\N	t	0	2020-04-30 14:13:39.982398+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27317	\N	56238401	\N	James Njoroge	25435016267	\N	\N	\N	\N	t	0	2020-04-30 14:13:39.983567+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27318	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0	2020-04-30 15:01:47.366732+03	\N	blacklist.xlsx	1	[["customer_name","mobile_number","customer_idnumber",null],["Milkah Warui",25425016568,64529784,null],["James Njoroge",25435016267,56238401,null]]
\N	\N	\N	\N	\N	\N	27319	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 15:01:50.459958+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27320	\N	64529784	\N	Milkah Warui	25425016568	\N	\N	\N	\N	t	0	2020-04-30 15:01:50.47413+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27321	\N	56238401	\N	James Njoroge	25435016267	\N	\N	\N	\N	t	0	2020-04-30 15:01:50.475744+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27322	\N	customer_idnumber	\N	customer_name	mobile_number	\N	\N	\N	\N	t	0	2020-04-30 15:02:44.561654+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27323	\N	64529784	\N	Milkah Warui	25425016568	\N	\N	\N	\N	t	0	2020-04-30 15:02:44.563949+03	\N	\N	0	\N
\N	\N	\N	\N	\N	\N	27324	\N	56238401	\N	James Njoroge	25435016267	\N	\N	\N	\N	t	0	2020-04-30 15:02:44.565658+03	\N	\N	0	\N
\.


--
-- Data for Name: tbl_password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_password_resets (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: tbl_pvd_serviceprovider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_pvd_serviceprovider (serviceproviderid, companyid, moneyservicename, provideridentifier, accountnumber, serviceprovidercategoryid, cutofflimit, settlementaccount, b2cbalance, c2bbalance, processingmode, addedby, serviceprovidertype, status, created_at, updated_at, deleted_at) FROM stdin;
1	2	Transfast	0	982551	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:18:29	2019-12-18 07:18:29	\N
2	3	MoneyTrans	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:19:25	2019-12-18 07:19:25	\N
3	4	Cash Express	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:20:13	2019-12-18 07:20:13	\N
4	5	Uremit	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:21:42	2019-12-18 07:21:42	\N
5	6	Xoom bank	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:22:16	2019-12-18 07:22:16	\N
6	7	Transfast Uganda	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:22:53	2019-12-18 07:22:53	\N
7	8	Uremit Uganda	0	334455	1	1000000.00		10000000.00	10000000.00	ACTUAL	1	MONEY TRANSFER SERVICE	ACTIVE	2019-12-18 07:24:09	2019-12-18 07:24:09	\N
\.


--
-- Data for Name: tbl_sec_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sec_roles (roleid, rolename, description, roletype, rolestatus, addedby, ipaddress, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tbl_sys_banks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_banks (date_time_added, added_by, date_time_modified, modified_by, bank_id, bank_name, branch_name, paybill, bank_code, branch_code, swift_code, pesalink_code, service_provider, switch_bank_code, bank_status, record_version) FROM stdin;
1583931337	\N	1583931337	\N	2	bank_name	branch_name	paybill	bank_code	branch_code	swift_code	pesalink_code	service_provider	switch_bank_code	bank_status	0
1583931337	\N	1583931337	\N	3	KENYA COMMERCIAL BANK	EASTLEIGH	522522	01	091	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	4	KENYA COMMERCIAL BANK	C.P.C.	522522	01	092	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	5	KENYA COMMERCIAL BANK	HEAD OFFICE	522522	01	094	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	6	KENYA COMMERCIAL BANK	WOTE	522522	01	095	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	7	KENYA COMMERCIAL BANK	HEAD OFFICE FINANCE	522522	01	096	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	8	KENYA COMMERCIAL BANK	Moi Avenue Nairobi	522522	01	100	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	9	KENYA COMMERCIAL BANK	KIPANDE HOUSE	522522	01	101	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	10	KENYA COMMERCIAL BANK	TREASURY SQUARE (MSA)	522522	01	102	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	11	KENYA COMMERCIAL BANK	NAKURU	522522	01	103	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	12	KENYA COMMERCIAL BANK	KENYATTA CONFERENCE CENTRE	522522	01	104	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	13	KENYA COMMERCIAL BANK	KISUMU	522522	01	105	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	14	KENYA COMMERCIAL BANK	KERICHO	522522	01	106	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	15	KENYA COMMERCIAL BANK	TOM MBOYA STREET	522522	01	107	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	16	KENYA COMMERCIAL BANK	THIKA	522522	01	108	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	17	KENYA COMMERCIAL BANK	ELDORET KENYATTA AVENUE	522522	01	109	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	18	KENYA COMMERCIAL BANK	KAKAMEGA	522522	01	110	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	19	KENYA COMMERCIAL BANK	KILINDINI ROAD MSA	522522	01	111	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	20	KENYA COMMERCIAL BANK	NYERI	522522	01	112	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	21	KENYA COMMERCIAL BANK	INDUSTRIAL AREA NAIROBI	522522	01	113	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	22	KENYA COMMERCIAL BANK	RIVER ROAD	522522	01	114	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	23	KENYA COMMERCIAL BANK	MURANGA	522522	01	115	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	24	KENYA COMMERCIAL BANK	EMBU	522522	01	116	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	25	KENYA COMMERCIAL BANK	KANGEMA	522522	01	117	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	26	KENYA COMMERCIAL BANK	KIAMBU	522522	01	119	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	27	KENYA COMMERCIAL BANK	KARATINA	522522	01	120	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	28	KENYA COMMERCIAL BANK	SIAYA	522522	01	121	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	29	KENYA COMMERCIAL BANK	NYAHURURU	522522	01	122	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	30	KENYA COMMERCIAL BANK	MERU	522522	01	123	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	31	KENYA COMMERCIAL BANK	MUMIAS	522522	01	124	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	32	KENYA COMMERCIAL BANK	NANYUKI	522522	01	125	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	33	KENYA COMMERCIAL BANK	MOYALE	522522	01	127	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	34	KENYA COMMERCIAL BANK	KIKUYU	522522	01	129	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	35	KENYA COMMERCIAL BANK	TALA	522522	01	130	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	36	KENYA COMMERCIAL BANK	KAJIADO	522522	01	131	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	37	KENYA COMMERCIAL BANK	KCB Custody services	522522	01	133	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	38	KENYA COMMERCIAL BANK	MATUU	522522	01	134	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	39	KENYA COMMERCIAL BANK	MVITA	522522	01	136	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	40	KENYA COMMERCIAL BANK	Jogoo Rd Nairobi	522522	01	137	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	41	KENYA COMMERCIAL BANK	CARD CENTRE	522522	01	139	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	42	KENYA COMMERCIAL BANK	MARSABIT	522522	01	140	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	43	KENYA COMMERCIAL BANK	SARIT CENTRE	522522	01	141	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	44	KENYA COMMERCIAL BANK	LOITOKITOK	522522	01	142	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	45	KENYA COMMERCIAL BANK	NANDI HILLS	522522	01	143	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	46	KENYA COMMERCIAL BANK	LODWAR	522522	01	144	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	47	KENYA COMMERCIAL BANK	UN-GIGIRI	522522	01	145	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	48	KENYA COMMERCIAL BANK	HOLA	522522	01	146	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	49	KENYA COMMERCIAL BANK	RUIRU	522522	01	147	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	50	KENYA COMMERCIAL BANK	MWINGI	522522	01	148	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	51	KENYA COMMERCIAL BANK	KITALE	522522	01	149	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	52	KENYA COMMERCIAL BANK	MANDERA	522522	01	150	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	53	KENYA COMMERCIAL BANK	KAPENGURIA	522522	01	151	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	54	KENYA COMMERCIAL BANK	KABARNET	522522	01	152	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	55	KENYA COMMERCIAL BANK	WAJIR	522522	01	153	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	56	KENYA COMMERCIAL BANK	MARALAL	522522	01	154	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	57	KENYA COMMERCIAL BANK	LIMURU	522522	01	155	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	58	KENYA COMMERCIAL BANK	UKUNDA	522522	01	157	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	59	KENYA COMMERCIAL BANK	ITEN	522522	01	158	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	60	KENYA COMMERCIAL BANK	GILGIL	522522	01	159	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	61	KENYA COMMERCIAL BANK	ONGATA RONGAI	522522	01	161	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	62	KENYA COMMERCIAL BANK	KITENGELA	522522	01	162	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	63	KENYA COMMERCIAL BANK	ELDAMA RAVINE	522522	01	163	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	64	KENYA COMMERCIAL BANK	Kibwezi	522522	01	164	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	65	KENYA COMMERCIAL BANK	KAPSABET	522522	01	166	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	66	KENYA COMMERCIAL BANK	UNIVERSITY WAY	522522	01	167	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	67	KENYA COMMERCIAL BANK	KCB Eldoret West	522522	01	168	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	68	KENYA COMMERCIAL BANK	GARISSA	522522	01	169	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	69	KENYA COMMERCIAL BANK	LAMU	522522	01	173	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	70	KENYA COMMERCIAL BANK	KILIFI	522522	01	174	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	71	KENYA COMMERCIAL BANK	MILIMANI BRANCH	522522	01	175	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	72	KENYA COMMERCIAL BANK	NYAMIRA	522522	01	176	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	73	KENYA COMMERCIAL BANK	Mukuruweini	522522	01	177	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	74	KENYA COMMERCIAL BANK	VILLAGE MARKET	522522	01	180	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	75	KENYA COMMERCIAL BANK	BOMET	522522	01	181	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	76	KENYA COMMERCIAL BANK	MBALE	522522	01	183	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	77	KENYA COMMERCIAL BANK	NAROK	522522	01	184	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	78	KENYA COMMERCIAL BANK	OTHAYA	522522	01	185	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	79	KENYA COMMERCIAL BANK	VOI	522522	01	186	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	80	KENYA COMMERCIAL BANK	WEBUYE	522522	01	188	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	81	KENYA COMMERCIAL BANK	SOTIK	522522	01	189	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	82	KENYA COMMERCIAL BANK	NAIVASHA	522522	01	190	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	83	KENYA COMMERCIAL BANK	KISII	522522	01	191	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	84	KENYA COMMERCIAL BANK	MIGORI	522522	01	192	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	85	KENYA COMMERCIAL BANK	GITHUNGURI	522522	01	193	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	86	KENYA COMMERCIAL BANK	MACHAKOS	522522	01	194	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	87	KENYA COMMERCIAL BANK	Kerugoya	522522	01	195	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	88	KENYA COMMERCIAL BANK	CHUKA	522522	01	196	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	89	KENYA COMMERCIAL BANK	BUNGOMA	522522	01	197	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	90	KENYA COMMERCIAL BANK	WUNDANYI	522522	01	198	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	91	KENYA COMMERCIAL BANK	MALINDI	522522	01	199	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	92	KENYA COMMERCIAL BANK	CAPITAL HILL	522522	01	201	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	93	KENYA COMMERCIAL BANK	KAREN	522522	01	202	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	94	KENYA COMMERCIAL BANK	LOKICHOGGIO	522522	01	203	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	95	KENYA COMMERCIAL BANK	Gateway Msa Road	522522	01	204	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	96	KENYA COMMERCIAL BANK	BURU BURU	522522	01	205	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	97	KENYA COMMERCIAL BANK	CHOGORIA BRANCH	522522	01	206	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	98	KENYA COMMERCIAL BANK	KANGARE	522522	01	207	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	99	KENYA COMMERCIAL BANK	KIANYAGA	522522	01	208	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	100	KENYA COMMERCIAL BANK	NKUBU	522522	01	209	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	101	KENYA COMMERCIAL BANK	OL KALOU	522522	01	210	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	102	KENYA COMMERCIAL BANK	MAKUYU	522522	01	211	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	103	KENYA COMMERCIAL BANK	MWEA	522522	01	212	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	104	KENYA COMMERCIAL BANK	NJAMBINI	522522	01	213	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	105	KENYA COMMERCIAL BANK	GATUNDU	522522	01	214	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	106	KENYA COMMERCIAL BANK	EMALI	522522	01	215	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	107	KENYA COMMERCIAL BANK	ISIOLO	522522	01	216	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	108	KENYA COMMERCIAL BANK	KCB Flamingo	522522	01	217	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	109	KENYA COMMERCIAL BANK	NJORO	522522	01	218	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	110	KENYA COMMERCIAL BANK	MUTOMO	522522	01	219	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	111	KENYA COMMERCIAL BANK	MARIAKANI	522522	01	220	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	112	KENYA COMMERCIAL BANK	MPEKETONI BRANCH	522522	01	221	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	113	KENYA COMMERCIAL BANK	MTITO ANDEI	522522	01	222	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	114	KENYA COMMERCIAL BANK	MTWAPA	522522	01	223	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	115	KENYA COMMERCIAL BANK	TAVETA	522522	01	224	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	116	KENYA COMMERCIAL BANK	KENGELENI	522522	01	225	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	117	KENYA COMMERCIAL BANK	GARSEN BRANCH	522522	01	226	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	118	KENYA COMMERCIAL BANK	WATAMU	522522	01	227	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	119	KENYA COMMERCIAL BANK	BONDO	522522	01	228	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	120	KENYA COMMERCIAL BANK	BUSIA	522522	01	229	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	121	KENYA COMMERCIAL BANK	HOMABAY	522522	01	230	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	122	KENYA COMMERCIAL BANK	KAPSOWAR BRANCH	522522	01	231	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	123	KENYA COMMERCIAL BANK	KEHANCHA BRANCH	522522	01	232	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	124	KENYA COMMERCIAL BANK	KEROKA	522522	01	233	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	125	KENYA COMMERCIAL BANK	KILGORIS	522522	01	234	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	126	KENYA COMMERCIAL BANK	KIMILILI	522522	01	235	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	127	KENYA COMMERCIAL BANK	LITEIN	522522	01	236	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	128	KENYA COMMERCIAL BANK	LONDIANI	522522	01	237	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	129	KENYA COMMERCIAL BANK	LUANDA	522522	01	238	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	130	KENYA COMMERCIAL BANK	MALABA	522522	01	239	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	131	KENYA COMMERCIAL BANK	MUHORONI	522522	01	240	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	132	KENYA COMMERCIAL BANK	OYUGIS	522522	01	241	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	133	KENYA COMMERCIAL BANK	UGUNJA	522522	01	242	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	134	KENYA COMMERCIAL BANK	UNITED MALL KISUMU	522522	01	243	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	135	KENYA COMMERCIAL BANK	SWEREM	522522	01	244	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	136	KENYA COMMERCIAL BANK	SONDU	522522	01	245	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	137	KENYA COMMERCIAL BANK	KISUMU WEST	522522	01	246	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	138	KENYA COMMERCIAL BANK	MARIGAT	522522	01	247	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	139	KENYA COMMERCIAL BANK	MOI'S BRIDGE	522522	01	248	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	140	KENYA COMMERCIAL BANK	Mashariki	522522	01	249	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	141	KENYA COMMERCIAL BANK	Naro Moro	522522	01	250	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	142	KENYA COMMERICAL BANK	KIRIAINI	522522	01	251	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	143	KENYA COMMERCIAL BANK	Egerton University	522522	01	252	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	144	KENYA COMMERCIAL BANK	MAUA	522522	01	253	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	145	KENYA COMMERCIAL BANK	KAWANGWARE	522522	01	254	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	146	KENYA COMMERCIAL BANK	KIMATHI BRANCH	522522	01	255	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	147	KENYA COMMERCIAL BANK	NAMANGA	522522	01	256	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	148	KENYA COMMERICAL BANK	GIKOMBA	522522	01	257	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	149	KENYA COMMERCIAL BANK	KWALE BRANCH	522522	01	258	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	150	KENYA COMMERCIAL BANK	PRESTIGE PLAZA	522522	01	259	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	151	KENYA COMMERICAL BANK	KARIOBANGI	522522	01	260	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	152	KENYA COMMERCIAL BANK	BIASHARA STREET	522522	01	263	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	153	KENYA COMMERCIAL BANK	NGARA	522522	01	266	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	154	KENYA COMMERCIAL BANK	KYUSO BRANCH	522522	01	267	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	155	KENYA COMMERCIAL BANK	MASII	522522	01	270	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	156	KENYA COMMERCIAL BANK	MENENGAI CRATER	522522	01	271	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	157	KENYA COMMERICAL BANK	TOWN CENTRE	522522	01	272	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	158	KENYA COMMERCIAL BANK	MAKINDU	522522	01	278	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	159	KENYA COMMERCIAL BANK	RONGO BRANCH	522522	01	283	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	160	KENYA COMMERCIAL BANK	ISIBANIA	522522	01	284	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	161	KENYA COMMERICAL BANK	KISERAIN	522522	01	285	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	162	KENYA COMMERCIAL BANK	MWEMBE TAYARI	522522	01	286	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	163	KENYA COMMERCIAL BANK	KISAUNI	522522	01	287	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	164	KENYA COMMERCIAL BANK	HAILE SALASSIE	522522	01	288	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	165	KENYA COMMERCIAL BANK	Salama House Mortgage Centre	522522	01	289	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	166	KENYA COMMERCIAL BANK	GARDEN PLAZA	522522	01	290	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	167	KENYA COMMERCIAL BANK	Sarit Centre Mortgage Centre	522522	01	291	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	168	KENYA COMMERCIAL BANK	CPC BULK CORPORATE CHEQUES	522522	01	292	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	169	KENYA COMMERCIAL BANK	TRADE SERVICES	522522	01	293	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	170	KENYA COMMERCIAL BANK	NAIROBI HIGH COURT	522522	01	295	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	171	KENYA COMMERCIAL BANK	MOMBASA HIGH COURT	522522	01	296	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	172	KENYA COMMERCIAL BANK	KISUMU AIRPORT	522522	01	297	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	173	KENYA COMMERCIAL BANK	PORT VICTORIA	522522	01	298	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	174	KENYA COMMERCIAL BANK	MOI INTERNATIONAL AIRPORT	522522	01	299	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	175	KENYA COMMERCIAL BANK	NYALI	522522	01	300	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	176	KENYA COMMERCIAL BANK	WESTGATE ADVANTAGE	522522	01	301	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	177	KENYA COMMERCIAL BANK	DIASPORA	522522	01	302	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	178	KENYA COMMERCIAL BAK	KISII WEST BRANCH	522522	01	303	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	179	KENYA COMMERCIAL BANK	MBITA	522522	01	304	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	180	KENYA COMMERCIAL BANK	SORI	522522	01	305	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	181	KENYA COMMERCIAL BANK	HURLINGHAM	522522	01	306	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	182	KENYA COMMERCIAL BANK	KIBERA	522522	01	307	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	183	KENYA COMMERCIAL BANK	THIKA ROAD MALL	522522	01	308	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	184	KENYA COMMERCIAL BANK	KASARANI	522522	01	309	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	185	KENYA COMMERCIAL BANK	KCB MAASAI MARA	522522	01	310	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	186	KENYA COMMERCIAL BANK	KABARTONJO	522522	01	311	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	187	KENYA COMMERCIAL BANK	KCB ELDORET EAST	522522	01	312	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	188	KENYA COMMERCIAL BANK	KCB KIKIMA	522522	01	313	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	189	KENYA COMMERCIAL BANK	KCB JKUAT	522522	01	314	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	190	KENYA COMMERCIAL BANK	KCB Changamwe	522522	01	315	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	191	KENYA COMMERCIAL BANK	KCB MAKONGENI	522522	01	316	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	192	KENYA COMMERCIAL BANK	KCB Syokimau	522522	01	317	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	193	KENYA COMMERCIAL BANK	MOI REFFERAL HOSPITAL	522522	01	318	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	194	KENYA COMMERCIAL BANK	KITALE ADVANTAGE	522522	01	319	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	195	KENYA COMMERCIAL BANK	LAVINGTON	522522	01	320	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	196	KENYA COMMERCIAL BANK	ICD KIBARANI	522522	01	321	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	197	KENYA COMMERCIAL BANK	RIVERSIDE ADVANTAGE	522522	01	322	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	198	KENYA COMMERCIAL BANK	GIGIRI SQUARE	522522	01	323	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	199	KENYA COMMERCIAL BANK	JKIA	522522	01	326	KCBLKENX	40401000	PI/SAF	B0001	ACTIVE	0
1583931337	\N	1583931337	\N	200	STANDARD CHARTERED BANK	ELDORET	\N	02	000	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	201	STANDARD CHARTERED BANK	KERICHO	\N	02	001	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	202	STANDARD CHARTERED BANK	KISUMU	\N	02	002	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	203	STANDARD CHARTERED BANK	KITALE	\N	02	003	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	204	STANDARD CHARTERED BANK	TREASURY SQUARE (MSA)	\N	02	004	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	205	STANDARD CHARTERED BANK	KILINDINI	\N	02	005	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	206	STANDARD CHARTERED BANK	KENYATTA AVENUE	\N	02	006	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	207	STANDARD CHARTERED BANK	MOI AVENUE	\N	02	008	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	208	STANDARD CHARTERED BANK	NAKURU	\N	02	009	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	209	STANDARD CHARTERED BANK	NANYUKI	\N	02	010	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	210	STANDARD CHARTERED BANK	NYERI	\N	02	011	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	211	STANDARD CHARTERED BANK	THIKA	\N	02	012	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	212	STANDARD CHARTERED BANK	WESTLANDS	\N	02	015	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	213	STANDARD CHARTERED BANK	MACHAKOS	\N	02	016	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	214	STANDARD CHARTERED BANK	MERU	\N	02	017	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	215	STANDARD CHARTERED BANK	HARAMBEE / HAILE SELASSIE	\N	02	019	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	216	STANDARD CHARTERED BANK	KIAMBU	\N	02	020	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	217	STANDARD CHARTERED BANK	INDUSTRIAL AREA (NBI)	\N	02	053	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	218	STANDARD CHARTERED BANK	KAKAMEGA	\N	02	054	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	219	STANDARD CHARTERED BANK	MALINDI	\N	02	060	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	220	STANDARD CHARTERED BANK	KOINANGE STREET	\N	02	064	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	221	STANDARD CHARTERED BANK	YAYA CENTRE	\N	02	071	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	222	STANDARD CHARTERED BANK	RUARAKA BRANCH	\N	02	072	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	223	STANDARD CHARTERED BANK	LANGATA	\N	02	073	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	224	STANDARD CHARTERED BANK	KAREN BRANCH	\N	02	075	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	225	STANDARD CHARTERED BANK	MUTHAIGA	\N	02	076	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	226	STANDARD CHARTERED BANK	CENTRAL OPERATION UNIT (COU)	\N	02	078	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	227	STANDARD CHARTERED BANK	UKAY BRANCH	\N	02	079	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	228	STANDARD CHARTERED BANK	EASTLEIGH BRANCH	\N	02	080	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	229	STANDARD CHARTERED BANK	KISII BRANCH	\N	02	081	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	230	STANDARD CHARTERED BANK	UPPERHILL	\N	02	082	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	231	STANDARD CHARTERED BANK	NYALI	\N	02	083	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	232	STANDARD CHARTERED BANK	CHIROMO	\N	02	084	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	233	STANDARD CHARTERED BANK	GREENSPAN	\N	02	085	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	234	STANDARD CHARTERED BANK	THE T-MALL	\N	02	086	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	235	STANDARD CHARTERED BANK	THE JUNCTION	\N	02	087	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	236	STANDARD CHARTERED BANK	KITENGELA	\N	02	089	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	237	STANDARD CHARTERED BANK	BUNGOMA	\N	02	090	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	238	STANDARD CHARTERED BANK	THE THIKA ROAD MALL	\N	02	091	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	239	STANDARD CHARTERED BANK	UN Gigiri	\N	02	092	SCBLKENX	40402000	Pesalink	B0002	ACTIVE	0
1583931337	\N	1583931337	\N	240	BARCLAYS BANK OF KENYA LTD.	LOCAL HEAD OFFICE	\N	03	001	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	241	BARCLAYS BANK OF KENYA LTD.	KAPSABET	\N	03	002	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	242	BARCLAYS BANK OF KENYA LTD.	ELDORET	\N	03	003	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	243	BARCLAYS BANK OF KENYA LTD.	EMBU	\N	03	004	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	244	BARCLAYS BANK OF KENYA LTD.	MURANGA	\N	03	005	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	245	BARCLAYS BANK OF KENYA LTD.	KAPENGURIA BRANCH	\N	03	006	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	246	BARCLAYS BANK OF KENYA LTD.	KERICHO	\N	03	007	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	247	BARCLAYS BANK OF KENYA LTD.	KISII	\N	03	008	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	248	BARCLAYS BANK OF KENYA LTD.	KISUMU	\N	03	009	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	249	BARCLAYS BANK OF KENYA LTD.	NAIROBI SOUTH'C'(RED CROSS) BRAN	\N	03	010	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	250	BARCLAYS BANK OF KENYA LTD.	LIMURU	\N	03	011	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	251	BARCLAYS BANK OF KENYA LTD.	MALINDI	\N	03	012	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	252	BARCLAYS BANK OF KENYA LTD.	MERU	\N	03	013	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	253	BARCLAYS BANK OF KENYA LTD.	EASTLEIGH	\N	03	014	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	254	BARCLAYS BANK OF KENYA LTD.	KITUI BRANCH	\N	03	015	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	255	BARCLAYS BANK OF KENYA LTD.	NKURAMAH ROAD	\N	03	016	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	256	BARCLAYS BANK OF KENYA LTD.	GARISSA	\N	03	017	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	257	BARCLAYS BANK OF KENYA LTD.	NYAMIRA	\N	03	018	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	258	BARCLAYS BANK OF KENYA LTD.	KILIFI	\N	03	019	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	259	BARCLAYS BANK OF KENYA LTD.	OFFICEPARK WESTLANDS	\N	03	020	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	260	BARCLAYS BANK OF KENYA LTD.	BARCLAYS BANK OF KENYA LTD.	\N	03	021	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	261	BARCLAYS BANK OF KENYA LTD.	NAFEX	\N	03	022	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	262	BARCLAYS BANK OF KENYA LTD.	GILGIL BRANCH	\N	03	023	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	263	BARCLAYS BANK OF KENYA LTD.	GITHURAI BRANCH	\N	03	024	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	264	BARCLAYS BANK OF KENYA LTD.	KAKAMEGA	\N	03	026	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	265	BARCLAYS BANK OF KENYA LTD.	NAKURU/NYAHU/MOLO/ELDA/NAIVA/OLK	\N	03	027	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	266	BARCLAYS BANK OF KENYA LTD.	BURU BURU BRANCH	\N	03	028	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	267	BARCLAYS BANK OF KENYA LTD.	BOMET BRANCH	\N	03	029	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	268	BARCLAYS BANK OF KENYA LTD.	NYERI / OTHAYA / KARATINA / NANY	\N	03	030	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	269	BARCLAYS BANK OF KENYA LTD.	THIKA / RUIRU	\N	03	031	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	270	BARCLAYS BANK OF KENYA LTD.	PORT BRANCH MOMBASA	\N	03	032	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	271	BARCLAYS BANK OF KENYA LTD.	GIKOBA BRANCH	\N	03	033	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	272	BARCLAYS BANK OF KENYA LTD.	KAWANGWARE BRANCH	\N	03	034	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	273	BARCLAYS BANK OF KENYA LTD.	MBALE	\N	03	035	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	274	BARCLAYS BANK OF KENYA LTD.	PREMIER BRANCH	\N	03	036	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	275	BARCLAYS BANK OF KENYA LTD.	RIVER ROAD	\N	03	037	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	276	BARCLAYS BANK OF KENYA LTD.	CHOMBA HOUSE	\N	03	038	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	277	BARCLAYS BANK OF KENYA LTD.	MUMIAS BRANCH	\N	03	039	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	278	BARCLAYS BANK OF KENYA LTD.	MACHAKOS / KITUI	\N	03	040	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	279	BARCLAYS BANK OF KENYA LTD.	NAROK BRANCH	\N	03	041	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	280	BARCLAYS BANK OF KENYA LTD.	ISIOLO BRANCH	\N	03	042	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	281	BARCLAYS BANK OF KENYA LTD.	NGONG	\N	03	043	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	282	BARCLAYS BANK OF KENYA LTD.	MAUA BRANCH	\N	03	044	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	283	BARCLAYS BANK OF KENYA LTD.	HURLINGHAM / YAYA CENTRE	\N	03	045	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	284	BARCLAYS BANK OF KENYA LTD.	MAKUPA BRANCH	\N	03	046	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	285	BARCLAYS BANK OF KENYA LTD.	DEVELOPMENT HOUSE BRANCH	\N	03	047	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	286	BARCLAYS BANK OF KENYA LTD.	BUNGOMA	\N	03	048	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	287	BARCLAYS BANK OF KENYA LTD.	LAVINGTON	\N	03	049	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	288	BARCLAYS BANK OF KENYA LTD.	TALA	\N	03	050	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	289	BARCLAYS BANK OF KENYA LTD.	HOMABAY	\N	03	051	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	290	BARCLAYS BANK OF KENYA LTD.	ONGATA RONGAI	\N	03	052	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	291	BARCLAYS BANK OF KENYA LTD.	OTHAYA BRANCH	\N	03	053	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	292	BARCLAYS BANK OF KENYA LTD.	VOI	\N	03	054	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	293	BARCLAYS BANK OF KENYA LTD.	MUTHAIGA BRANCH	\N	03	055	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	294	BARCLAYS BANK OF KENYA LTD.	BARCKLAYS ADVISORY AND REG. SERVIC	\N	03	056	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	295	BARCLAYS BANK OF KENYA LTD.	GITHUNGURI BRANCH	\N	03	057	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	296	BARCLAYS BANK OF KENYA LTD.	WEBUYE	\N	03	058	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	297	BARCLAYS BANK OF KENYA LTD.	KASARANI BRANCH	\N	03	059	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	298	BARCLAYS BANK OF KENYA LTD.	CHUKA BRANCH	\N	03	060	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	299	BARCLAYS BANK OF KENYA LTD.	WESTGATE BRANCH	\N	03	061	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	300	BARCLAYS BANK OF KENYA LTD.	KABARNET	\N	03	062	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	301	BARCLAYS BANK OF KENYA LTD.	KERUGOYA	\N	03	063	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	302	BARCLAYS BANK OF KENYA LTD.	TAVETA	\N	03	064	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	303	BARCLAYS BANK OF KENYA LTD.	KAREN / NGONG	\N	03	065	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	304	BARCLAYS BANK OF KENYA LTD.	WUNDANYI BRANCH	\N	03	066	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	305	BARCLAYS BANK OF KENYA LTD.	RUARAKA BRANCH	\N	03	067	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	306	BARCLAYS BANK OF KENYA LTD.	KITENGELA BRANCH	\N	03	068	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	307	BARCLAYS BANK OF KENYA LTD.	WOTE BRANCH	\N	03	069	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	308	BARCLAYS BANK OF KENYA LTD.	ENTERPRISE ROAD BRANCH	\N	03	070	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	309	BARCLAYS BANK OF KENYA LTD.	NAKUMATT MERU BRANCH	\N	03	071	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	310	BARCLAYS BANK OF KENYA LTD.	JUJA BRANCH	\N	03	072	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	311	BARCLAYS BANK OF KENYA LTD.	WESTLANDS / SARIT CENTRE	\N	03	073	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	312	BARCLAYS BANK OF KENYA LTD.	KIKUYU BRANCH	\N	03	074	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	313	BARCLAYS BANK OF KENYA LTD.	MOI NBI/SONALUX/ACCRA/KENYAT/LAN	\N	03	075	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	314	BARCLAYS BANK OF KENYA LTD.	NYALI BRANCH	\N	03	076	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	315	BARCLAYS BANK OF KENYA LTD.	BARCLAYS BANK OF KENYA LTD.	\N	03	077	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	316	BARCLAYS BANK OF KENYA LTD.	KIRIAINI BRANCH	\N	03	078	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	317	BARCLAYS BANK OF KENYA LTD.	BUTERE ROAD	\N	03	079	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	318	BARCLAYS BANK OF KENYA LTD.	MIGORI BRANCH	\N	03	080	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	319	BARCLAYS BANK OF KENYA LTD.	DIGO ROAD	\N	03	081	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	320	BARCLAYS BANK OF KENYA LTD.	HAILE SELASSIE / PIONEER HOUSE	\N	03	082	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	321	BARCLAYS BANK OF KENYA LTD.	NAIROBI UNIVERSITY BRANCH	\N	03	083	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	322	BARCLAYS BANK OF KENYA LTD.	BUNYALA ROAD	\N	03	084	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	323	BARCLAYS BANK OF KENYA LTD.	NAIROBI WEST BRANCH	\N	03	086	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	324	BARCLAYS BANK OF KENYA LTD.	PARKLANDS (HIGHRIDGE) BRANCH	\N	03	087	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	325	BARCLAYS BANK OF KENYA LTD.	BUSIA BRANCH	\N	03	088	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	326	BARCLAYS BANK OF KENYA LTD.	PANGANI BRANCH	\N	03	089	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	327	BARCLAYS BANK OF KENYA LTD.	ABC PRESTIGE	\N	03	090	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	328	BARCLAYS BANK OF KENYA LTD.	KARIOBANGI BRANCH	\N	03	093	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	329	BARCLAYS BANK OF KENYA LTD.	QWAY/HBEE/GARISA/EAGL/UNIO/MKT/N	\N	03	094	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	330	BARCLAYS BANK OF KENYA LTD.	NAKUMATT EMBAKASI	\N	03	095	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	331	BARCLAYS BANK OF KENYA LTD.	BMFL	\N	03	096	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	332	BARCLAYS BANK OF KENYA LTD.	BARCLAYS BANK OF KENYA LTD.	\N	03	097	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	333	BARCLAYS BANK OF KENYA LTD.	DIANI	\N	03	100	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	334	BARCLAYS BANK OF KENYA LTD.	JKIA	\N	03	103	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	335	BARCLAYS BANK OF KENYA LTD.	VILLAGE MARKET PRESTIGE	\N	03	105	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	336	BARCLAYS BANK OF KENYA LTD.	SARIT PRESTIGE	\N	03	106	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	337	BARCLAYS BANK OF KENYA LTD.	YAYA PRESTIGE	\N	03	109	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	338	BARCLAYS BANK OF KENYA LTD.	NAIVASHA	\N	03	111	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	339	BARCLAYS BANK OF KENYA LTD.	MARKET BRANCH	\N	03	113	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	340	BARCLAYS BANK OF KENYA LTD.	CHANGAMWE	\N	03	114	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	341	BARCLAYS BANK OF KENYA LTD.	RAHIMTULLA PRESTIGE	\N	03	117	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	342	BARCLAYS BANK OF KENYA LTD.	NAKURU WEST BRANCH	\N	03	125	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	343	BARCLAYS BANK OF KENYA LTD.	BAMBURI	\N	03	128	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	344	BARCLAYS BANK OF KENYA LTD.	HARAMBEE AVENUE PRESTIGE	\N	03	130	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	345	BARCLAYS BANK OF KENYA LTD.	KITALE	\N	03	132	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	346	BARCLAYS BANK OF KENYA LTD.	NYAHURURU	\N	03	139	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	347	BARCLAYS BANK OF KENYA LTD.	TREASURY OPERATIONS	\N	03	144	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	348	BARCLAYS BANK OF KENYA LTD.	MOI AVENUE MOMBASA PRESTIGE	\N	03	145	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	349	BARCLAYS BANK OF KENYA LTD.	CASH MONITORING UNIT	\N	03	151	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	350	BARCLAYS BANK OF KENYA LTD.	NANYUKI	\N	03	190	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	351	BARCLAYS BANK OF KENYA LTD.	KARATINA	\N	03	206	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	352	BARCLAYS BANK OF KENYA LTD.	NYERERE PRESTIGE	\N	03	220	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	353	BARCLAYS BANK OF KENYA LTD.	CONSUMER OPERATION	\N	03	273	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	354	BARCLAYS BANK OF KENYA LTD.	FINANCE DEPARTMENT	\N	03	300	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	355	BARCLAYS BANK OF KENYA LTD.	DOCUMENTS AND SERCURITIES	\N	03	337	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	356	BARCLAYS BANK OF KENYA LTD.	RETAIL CREDIT TEAM	\N	03	340	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	357	BARCLAYS BANK OF KENYA LTD.	CREDIT OPERATIONS	\N	03	354	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	358	BARCLAYS BANK OF KENYA LTD.	HEAD OFFICE	\N	03	400	BARCKENX	40403000	Pesalink	B0003	ACTIVE	0
1583931337	\N	1583931337	\N	359	BANK OF INDIA	NAIROBI BRANCH	\N	05	000	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	360	BANK OF INDIA	MOMBASA BRANCH	\N	05	001	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	361	BANK OF INDIA	Industrial Area Branch	\N	05	002	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	362	BANK OF INDIA	WESTLANDS	\N	05	003	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	363	BANK OF INDIA	KISUMU	\N	05	004	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	364	BANK OF INDIA	ELDORET	\N	05	005	BKIDKENA	40405000	Pesalink	B0004	ACTIVE	0
1583931337	\N	1583931337	\N	365	BANK OF BARODA	NAIROBI MAIN OFFICE	\N	06	000	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	366	BANK OF BARODA	DIGO RD / MAKADARA RD (MSA)	\N	06	002	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	367	BANK OF BARODA	THIKA	\N	06	004	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	368	BANK OF BARODA	KISUMU	\N	06	005	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	369	BANK OF BARODA	Sarit Branch	\N	06	006	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	370	BANK OF BARODA	Industrial Area	\N	06	007	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	371	BANK OF BARODA	ELDORET	\N	06	008	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	372	BANK OF BARODA	NAKURU	\N	06	009	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	373	BANK OF BARODA	KAKAMEGA	\N	06	010	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	374	BANK OF BARODA	NYALI	\N	06	011	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	375	BANK OF BARODA	MERU	\N	06	012	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	376	BANK OF BARODA	DIAMOND PLAZA	\N	06	015	BARBKENA	40406000	Pesalink	B0005	ACTIVE	0
1583931337	\N	1583931337	\N	377	COMMERCIAL BANK OF AFRICA	HEAD OFFICE	880100	07	000	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	378	COMMERCIAL BANK OF AFRICA	UPPER HILL	880100	07	001	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	379	COMMERCIAL BANK OF AFRICA	WABERA STREET	880100	07	002	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	380	COMMERCIAL BANK OF AFRICA	MAMA NGINA	880100	07	003	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	381	COMMERCIAL BANK OF AFRICA	WESTLANDS BRANCH	880100	07	004	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	382	COMMERCIAL BANK OF AFRICA	INDUSTRIAL AREA	880100	07	005	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	383	COMMERCIAL BANK OF AFRICA	MAMLAKA	880100	07	006	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	384	COMMERCIAL BANK OF AFRICA	VILLAGE MARKET	880100	07	007	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	385	COMMERCIAL BANK OF AFRICA	CARGO CENTRE	880100	07	008	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	386	COMMERCIAL BANK OF AFRICA	PARKSIDE	880100	07	009	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	387	COMMERCIAL BANK OF AFRICA	GALLERIA MALL	880100	07	016	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	388	COMMERCIAL BANK OF AFRICA	JUNCTION	880100	07	017	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	389	COMMERCIAL BANK OF AFRICA	THIKA ROAD MALL	880100	07	018	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	390	COMMERCIAL BANK OF AFRICA	GREENSPAN MALL	880100	07	019	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	391	COMMERCIAL BANK OF AFRICA	MOI AVENUE MOMBASA	880100	07	020	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	392	COMMERCIAL BANK OF AFRICA	MERU	880100	07	021	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	393	COMMERCIAL BANK OF AFRICA	NAKURU	880100	07	022	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	394	COMMERCIAL BANK OF AFRICA	BAMBURI	880100	07	023	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	395	COMMERCIAL BANK OF AFRICA	DIANI	880100	07	024	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	396	COMMERCIAL BANK OF AFRICA	CHANGAMWE BRANCH	880100	07	025	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	397	COMMERCIAL BANK OF AFRICA	ELDORET	880100	07	026	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	398	COMMERCIAL BANK OF AFRICA	KISUMU	880100	07	027	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	399	COMMERCIAL BANK OF AFRICA	THIKA	880100	07	028	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	400	COMMERCIAL BANK OF AFRICA	NANYUKI	880100	07	029	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	401	COMMERCIAL BANK OF AFRICA	YAYA CENTRE	880100	07	030	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	402	COMMERCIAL BANK OF AFRICA	Lavington	880100	07	031	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	403	COMMERCIAL BANK OF AFRICA	MACHAKOS	880100	07	032	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	404	COMMERCIAL BANK OF AFRIA	KIRINYAGA ROAD	880100	07	033	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	405	COMMERCIAL BANK OF AFRIA	KAREN HUB	880100	07	034	CBAFKENX	40407000	PI/SAF	B0006	ACTIVE	0
1583931337	\N	1583931337	\N	406	HABIB BANK LTD	MOMBASA BRANCH	\N	08	046	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	407	HABIB BANK LTD	MALINDI	\N	08	047	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	408	HABIB BANK LTD	KIMATHI  STREET	\N	08	048	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	409	HABIB BANK LTD	KENYATTA AVENUE	\N	08	049	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	410	HABIB BANK LTD	KISUMU	\N	08	086	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	411	HABIB BANK LTD	Industrial Area	\N	08	108	HABBKENX	40417000	Pesalink	B0007	ACTIVE	0
1583931337	\N	1583931337	\N	412	PRIME BANK	HEAD OFFICE RIVERSIDE	928800	10	000	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	413	PRIME BANK	KENINDIA HSE	928800	10	001	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	414	PRIME BANK	BIASHARA STREET	928800	10	002	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	415	PRIME BANK	MOMBASA	928800	10	003	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	416	PRIME BANK	WESTLANDS	928800	10	004	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	417	PRIME BANK	INDUSTRIAL AREA	928800	10	005	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	418	PRIME BANK	KISUMU	928800	10	006	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	419	PRIME BANK	PARKLANDS	928800	10	007	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	420	PRIME BANK	Riverside Drive Branch	928800	10	008	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	421	PRIME BANK	CARD CENTRE	928800	10	009	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	422	PRIME BANK	HURLINGHAM	928800	10	010	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	423	PRIME BANK	CAPITAL CENTRE	928800	10	011	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	424	PRIME BANK	NYALI	928800	10	012	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	425	PRIME BANK	KAMUKUNJI BRANCH	928800	10	014	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	426	PRIME BANK	ELDORET	928800	10	015	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	427	PRIME BANK	KAREN	928800	10	016	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	428	PRIME BANK	NAKURU	928800	10	017	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	429	PRIME BANK	GIGIRI	928800	10	018	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	430	PRIME BANK	THIKA BRANCH	928800	10	019	PRIEKENX	40410000	PI/SAF	B0009	ACTIVE	0
1583931337	\N	1583931337	\N	431	THE COOPERATIVE BANK OF KENYA	Head Office	400200	11	000	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	432	THE COOPERATIVE BANK OF KENYA	FINANCE AND ACCOUNTS	400200	11	001	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	433	THE COOPERATIVE BANK OF KENYA	CO-OP.BANK HOUSE	400200	11	002	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	434	THE COOPERATIVE BANK OF KENYA	KISUMU	400200	11	003	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	435	THE COOPERATIVE BANK OF KENYA	Nkurumah Road	400200	11	004	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	436	THE COOPERATIVE BANK OF KENYA	MERU	400200	11	005	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	437	THE COOPERATIVE BANK OF KENYA	NAKURU	400200	11	006	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	438	THE COOPERATIVE BANK OF KENYA	INDUSTRIAL AREA	400200	11	007	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	439	THE COOPERATIVE BANK OF KENYA	KISII	400200	11	008	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	440	THE COOPERATIVE BANK OF KENYA	MACHAKOS	400200	11	009	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	441	THE COOPERATIVE BANK OF KENYA	NYERI	400200	11	010	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	442	THE COOPERATIVE BANK OF KENYA	UKULIMA	400200	11	011	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	443	THE COOPERATIVE BANK OF KENYA	KERUGOYA	400200	11	012	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	444	THE COOPERATIVE BANK OF KENYA	ELDORET	400200	11	013	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	445	THE COOPERATIVE BANK OF KENYA	MOI AVENUE	400200	11	014	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	446	THE COOPERATIVE BANK OF KENYA	NAIVASHA	400200	11	015	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	447	THE COOPERATIVE BANK OF KENYA	NYAHURURU	400200	11	017	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	448	THE COOPERATIVE BANK OF KENYA	CHUKA	400200	11	018	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	449	THE COOPERATIVE BANK OF KENYA	WAKULIMA MARKET	400200	11	019	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	450	THE COOPERATIVE BANK OF KENYA	Eastleigh	400200	11	020	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	451	THE COOPERATIVE BANK OF KENYA	KIAMBU	400200	11	021	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	452	THE COOPERATIVE BANK OF KENYA	HOMA BAY	400200	11	022	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	453	THE COOPERATIVE BANK OF KENYA	EMBU	400200	11	023	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	454	THE COOPERATIVE BANK OF KENYA	KERICHO	400200	11	024	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	455	THE COOPERATIVE BANK OF KENYA	BUNGOMA	400200	11	025	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	456	THE COOPERATIVE BANK OF KENYA	MURANGA	400200	11	026	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	457	THE COOPERATIVE BANK OF KENYA	KAYOLE	400200	11	027	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	458	THE COOPERATIVE BANK OF KENYA	KARATINA	400200	11	028	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	459	THE COOPERATIVE BANK OF KENYA	UKUNDA	400200	11	029	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	460	THE COOPERATIVE BANK OF KENYA	MTWAPA	400200	11	030	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	461	THE COOPERATIVE BANK OF KENYA	UNIVERSITY WAY	400200	11	031	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	462	THE COOPERATIVE BANK OF KENYA	Buru Buru	400200	11	032	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	463	THE COOPERATIVE BANK OF KENYA	ATHI RIVER	400200	11	033	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	464	THE COOPERATIVE BANK OF KENYA	MUMIAS	400200	11	034	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	465	THE COOPERATIVE BANK OF KENYA	STIMA PLAZA	400200	11	035	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	466	THE COOPERATIVE BANK OF KENYA	WESTLANDS	400200	11	036	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	467	THE COOPERATIVE BANK OF KENYA	UPPERHILL	400200	11	037	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	468	THE COOPERATIVE BANK OF KENYA	Ongata Rongai	400200	11	038	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	469	THE COOPERATIVE BANK OF KENYA	THIKA	400200	11	039	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	470	THE COOPERATIVE BANK OF KENYA	Nacico	400200	11	040	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	471	THE COOPERATIVE BANK OF KENYA	KARIOBANGI	400200	11	041	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	472	THE COOPERATIVE BANK OF KENYA	KAWANGWARE BRANCH	400200	11	042	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	473	THE COOPERATIVE BANK OF KENYA	Makutano	400200	11	043	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	474	THE COOPERATIVE BANK OF KENYA	CANNON HOUSE BRANCH	400200	11	044	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	475	THE COOPERATIVE BANK OF KENYA	KIMATHI STREET BRANCH	400200	11	045	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	476	THE COOPERATIVE BANK OF KENYA	KITALE	400200	11	046	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	477	THE COOPERATIVE BANK OF KENYA	GITHURAI	400200	11	047	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	478	THE COOPERATIVE BANK OF KENYA	MAUA	400200	11	048	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	479	THE COOPERATIVE BANK OF KENYA	CITY HALL	400200	11	049	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	480	THE COOPERATIVE BANK OF KENYA	DIGO ROAD MOMBASA	400200	11	050	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	481	THE COOPERATIVE BANK OF KENYA	NAIROBI BUSINESS CENTRE	400200	11	051	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	482	THE COOPERATIVE BANK OF KENYA	KAKAMEGA	400200	11	052	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	483	THE COOPERATIVE BANK OF KENYA	MIGORI	400200	11	053	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	484	THE COOPERATIVE BANK OF KENYA	KENYATTA AVENUE	400200	11	054	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	485	THE COOPERATIVE BANK OF KENYA	Nkubu	400200	11	055	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	486	THE COOPERATIVE BANK OF KENYA	ENTERPRISE RD	400200	11	056	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	487	THE COOPERATIVE BANK OF KENYA	BUSIA	400200	11	057	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	488	THE COOPERATIVE BANK OF KENYA	SIAYA	400200	11	058	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	489	THE COOPERATIVE BANK OF KENYA	VOI	400200	11	059	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	490	THE COOPERATIVE BANK OF KENYA	MOMBASA	400200	11	060	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	491	THE COOPERATIVE BANK OF KENYA	MALINDI BRANCH	400200	11	061	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	492	THE COOPERATIVE BANK OF KENYA	ZIMMERMAN	400200	11	062	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	493	THE COOPERATIVE BANK OF KENYA	NAKURU EAST	400200	11	063	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	494	THE COOPERATIVE BANK OF KENYA	KITENGELA	400200	11	064	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	495	THE COOPERATIVE BANK OF KENYA	AGA KHAN WALK	400200	11	065	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	496	THE COOPERATIVE BANK OF KENYA	NAROK BRANCH	400200	11	066	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	497	THE COOPERATIVE BANK OF KENYA	KITUI	400200	11	067	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	498	THE COOPERATIVE BANK OF KENYA	NANYUKI	400200	11	068	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	499	THE COOPERATIVE BANK OF KENYA	EMBAKASI	400200	11	069	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	500	THE COOPERATIVE BANK OF KENYA	KIBERA BRANCH	400200	11	070	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	501	THE COOPERATIVE BANK OF KENYA	SIAKAGO	400200	11	071	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	502	THE COOPERATIVE BANK OF KENYA	KAPSABET BRANCH	400200	11	072	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	503	THE COOPERATIVE BANK OF KENYA	MBITA BRANCH	400200	11	073	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	504	THE COOPERATIVE BANK OF KENYA	KANGEMI	400200	11	074	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	505	THE COOPERATIVE BANK OF KENYA	DANDORA	400200	11	075	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	506	THE COOPERATIVE BANK OF KENYA	KAJIADO BRANCH	400200	11	076	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	507	THE COOPERATIVE BANK OF KENYA	TALA	400200	11	077	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	508	THE COOPERATIVE BANK OF KENYA	GIKOMBA	400200	11	078	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	509	THE COOPERATIVE BANK OF KENYA	RIVER ROAD	400200	11	079	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	510	THE COOPERATIVE BANK OF KENYA	NYAMIRA	400200	11	080	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	511	THE COOPERATIVE BANK OF KENYA	GARISSA	400200	11	081	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	512	THE COOPERATIVE BANK OF KENYA	BOMET	400200	11	082	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	513	THE COOPERATIVE BANK OF KENYA	KEROKA BRANCH	400200	11	083	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	514	THE COOPERATIVE BANK OF KENYA	GILGIL	400200	11	084	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	515	THE COOPERATIVE BANK OF KENYA	TOM MBOYA BRANCH	400200	11	085	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	516	THE COOPERATIVE BANK OF KENYA	LIKONI BRANCH	400200	11	086	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	517	THE COOPERATIVE BANK OF KENYA	DONHOLM	400200	11	087	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	518	THE COOPERATIVE BANK OF KENYA	MWINGI BRANCH	400200	11	088	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	519	THE COOPERATIVE BANK OF KENYA	\N	400200	11	089	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	520	THE COOPERATIVE BANK OF KENYA	WEBUYE	400200	11	090	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	521	THE COOPERATIVE BANK OF KENYA	SACCO CLEARING UNIT	400200	11	094	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	522	THE COOPERATIVE BANK OF KENYA	clearing Centre	400200	11	097	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	523	THE COOPERATIVE BANK OF KENYA	NDHIWA	400200	11	100	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	524	THE COOPERATIVE BANK OF KENYA	OYUGIS	400200	11	101	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	525	THE COOPERATIVE BANK OF KENYA	ISIOLO	400200	11	102	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	526	THE COOPERATIVE BANK OF KENYA	ELDORET WEST	400200	11	103	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	527	THE COOPERATIVE BANK OF KENYA	CHANGAMWE	400200	11	104	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	528	THE COOPERATIVE BANK OF KENYA	KISUMU EAST	400200	11	105	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	529	THE COOPERATIVE BANK OF KENYA	GITHURAI KIMBO	400200	11	106	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	530	THE COOPERATIVE BANK OF KENYA	MLOLONGO	400200	11	107	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	531	THE COOPERATIVE BANK OF KENYA	KILIFI	400200	11	108	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	532	THE COOPERATIVE BANK OF KENYA	OL KALAU	400200	11	109	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	533	THE COOPERATIVE BANK OF KENYA	MBALE	400200	11	110	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	534	THE COOPERATIVE BANK OF KENYA	KIMILILI	400200	11	111	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	535	THE COOPERATIVE BANK OF KENYA	KISII EAST	400200	11	112	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	536	THE COOPERATIVE BANK OF KENYA 	KILGORIS BRANCH	400200	11	113	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	537	THE COOPERATIVE BANK OF KENYA	WOTE	400200	11	114	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	538	THE COOPERATIVE BANK OF KENYA	MALABA	400200	11	116	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	539	THE COOPERATIVE BANK OF KENYA	MOLO	400200	11	117	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	540	THE COOPERATIVE BANK OF KENYA	MWEA	400200	11	118	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	541	THE COOPERATIVE BANK OF KENYA	KUTUS	400200	11	119	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	542	THE COOPERATIVE BANK OF KENYA	UMOJA	400200	11	120	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	543	THE COOPERATIVE BANK OF KENYA	EMBAKASI JUNCTION	400200	11	121	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	544	THE COOPERATIVE BANK OF KENYA	KONGOWEA	400200	11	122	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	545	THE COOPERATIVE BANK OF KENYA	LANGATA ROAD	400200	11	123	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	546	THE COOPERATIVE BANK OF KENYA	JUJA	400200	11	124	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	547	THE COOPERATIVE BANK OF KENYA	NGONG	400200	11	125	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	548	THE COOPERATIVE BANK OF KENYA	KAWANGWARE 46	400200	11	126	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	549	THE COOPERATIVE BANK OF KENYA	MOMBASA ROAD	400200	11	127	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	550	THE COOPERATIVE BANK OF KENYA	MARSABIT	400200	11	128	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	551	THE COOPERATIVE BANK OF KENYA	DAGORETTI CORNER	400200	11	130	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	552	THE COOPERATIVE BANK OF KENYA	OTHAYA	400200	11	131	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	553	THE COOPERATIVE BANK OF KENYA	LIMURU	400200	11	132	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	554	THE COOPERATIVE BANK OF KENYA	KIKUYU	400200	11	133	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	555	THE COOPERATIVE BANK OF KENYA	GITHUNGURI	400200	11	134	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	556	THE COOPERATIVE BANK OF KENYA	KAREN	400200	11	135	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	557	THE COOPERATIVE BANK OF KENYA	MPEKETONI	400200	11	136	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	558	THE COOPERATIVE BANK OF KENYA	GATUNDU	400200	11	137	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	559	THE COOPERATIVE BANK OF KENYA	RUIRU	400200	11	138	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	560	THE COOPERATIVE BANK OF KENYA	NYALI MALL	400200	11	139	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	561	THE COOPERATIVE BANK OF KENYA	YALA	400200	11	140	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	562	THE COOPERATIVE BANK OF KENYA	MAASAI MALL- ONGATA RONGAI	400200	11	141	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	563	THE COOPERATIVE BANK OF KENYA	THIKA ROAD MALL	400200	11	142	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	564	THE COOPERATIVE BANK OF KENYA	Nandi Hills	400200	11	144	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	565	THE COOPERATIVE BANK OF KENYA	LODWAR	400200	11	145	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	566	THE COOPERATIVE BANK OF KENYA	Engineer	400200	11	147	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	567	THE COOPERATIVE BANK OF KENYA	RONGO	400200	11	148	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	568	THE COOPERATIVE BANK OF KENYA	LAVINGTON MALL	400200	11	149	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	569	THE COOPERATIVE BANK OF KENYA	BONDO	400200	11	150	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	570	THE COOPERATIVE BANK OF KENYA	GIGIRI MALL	400200	11	151	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	571	THE COOPERATIVE BANK OF KENYA	UNITED MALL KISUMU	400200	11	152	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	572	THE COOPERATIVE BANK OF KENYA	GREEN HOUSE MALL	400200	11	153	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	573	THE COOPERATIVE BANK OF KENYA	SHARES OPERATIONS	400200	11	228	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	574	THE COOPERATIVE BANK OF KENYA	Back Office Operations	400200	11	247	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	575	THE COOPERATIVE BANK OF KENYA	E-CHANNELS UNIT	400200	11	250	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	576	THE COOPERATIVE BANK OF KENYA	DIASPORA BANKING BRANCH	400200	11	254	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	577	THE COOPERATIVE BANK OF KENYA	KILINDINI PORT	400200	11	266	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	578	THE COOPERATIVE BANK OF KENYA	MONEY TRANSFER	400200	11	270	KCOOKENA	40411000	PI/SAF	B0010	ACTIVE	0
1583931337	\N	1583931337	\N	579	NATIONAL BANK 	Central Business Unit	547700	12	000	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	580	NATIONAL BANK 	KENYATTA	547700	12	002	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	581	NATIONAL BANK 	HARAMBEE	547700	12	003	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	582	NATIONAL BANK 	HILL	547700	12	004	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	583	NATIONAL BANK 	BUSIA	547700	12	005	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	584	NATIONAL BANK 	KIAMBU	547700	12	006	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	585	NATIONAL BANK 	MERU	547700	12	007	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	586	NATIONAL BANK 	KARATINA	547700	12	008	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	587	NATIONAL BANK 	NAROK	547700	12	009	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	588	NATIONAL BANK 	KISII	547700	12	010	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	589	NATIONAL BANK 	MALINDI	547700	12	011	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	590	NATIONAL BANK 	NYERI	547700	12	012	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	591	NATIONAL BANK 	KITALE	547700	12	013	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	592	NATIONAL BANK	EASTLEIGH	547700	12	015	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	593	NATIONAL BANK 	LIMURU	547700	12	016	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	594	NATIONAL BANK 	KITUI	547700	12	017	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	595	NATIONAL BANK 	MOLO	547700	12	018	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	596	NATIONAL BANK 	BUNGOMA	547700	12	019	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	597	NATIONAL BANK 	NKURUMAH	547700	12	020	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	598	NATIONAL BANK 	KAPSABET	547700	12	021	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	599	NATIONAL BANK 	AWENDO	547700	12	022	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	600	NATIONAL BANK 	Portway-msa	547700	12	023	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	601	NATIONAL BANK 	HOSPITAL	547700	12	025	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	602	NATIONAL BANK 	RUIRU	547700	12	026	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	603	NATIONAL BANK	Ongata Rongai	547700	12	027	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	604	NATIONAL BANK	EMBU	547700	12	028	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	605	NATIONAL BANK	KAKAMEGA	547700	12	029	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	606	NATIONAL BANK 	NAKURU	547700	12	030	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	607	NATIONAL BANK 	UKUNDA	547700	12	031	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	608	NATIONAL BANK 	UPPER-HILL	547700	12	032	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	609	NATIONAL BANK 	NANDI HILLS	547700	12	033	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	610	NATIONAL BANK 	MIGORI BRANCH	547700	12	034	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	611	NATIONAL BANK 	WESTLANDS	547700	12	035	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	612	NATIONAL BANK 	TIMES TOWER	547700	12	036	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	613	NATIONAL BANK 	MAUA BRANCH	547700	12	037	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	614	NATIONAL BANK 	WILSON AIRPORT	547700	12	038	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	615	NATIONAL BANK 	J.K.I.A	547700	12	039	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	616	NATIONAL BANK 	ELDORET	547700	12	040	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	617	NATIONAL BANK 	MOI'SBRIDGE	547700	12	041	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	618	NATIONAL BANK 	MUTOMO	547700	12	042	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	619	NATIONAL BANK 	KIANJAI	547700	12	043	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	620	NATIONAL BANK 	KENYATTA UNIVERSITY	547700	12	044	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	621	NATIONAL BANK 	ST. PAUL'S UNIVERSITY	547700	12	045	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	622	NATIONAL BANK 	MOI UNIVERSITY	547700	12	046	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	623	NATIONAL BANK 	MOI INTERNATIONAL AIRPORT MOMBASA	547700	12	047	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	624	NATIONAL BANK 	MACHAKOS	547700	12	048	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	625	NATIONAL BANK 	Kitengela	547700	12	049	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	626	NATIONAL BANK 	KISUMU	547700	12	050	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	627	NATIONAL BANK 	MTWAPA BRANCH	547700	12	051	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	628	NATIONAL BANK	CHANGAMWE	547700	12	052	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	629	NATIONAL BANK 	GARISSA	547700	12	053	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	630	NATIONAL BANK 	THIKA	547700	12	054	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	631	NATIONAL BANK 	Mombasa Polytechnic University Col	547700	12	055	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	632	NATIONAL BANK	BOMET	547700	12	056	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	633	NATIONAL BANK 	GREENSPAN	547700	12	058	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	634	NATIONAL BANK 	SAMEER PARK	547700	12	059	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	635	NATIONAL BANK	SEKU BRANCH	547700	12	060	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	636	NATIONAL BANK 	NGONG ROAD	547700	12	061	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	637	NATIONAL BANK 	MOI AVENUE	547700	12	062	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	638	NATIONAL BANK 	MOUNTAIN MALL	547700	12	063	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	639	NATIONAL BANK 	NYALI CENTRE	547700	12	065	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	640	NATIONAL BANK 	KILIFI	547700	12	066	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	641	NATIONAL BANK 	SOUTH C BRANCH - KEBS	547700	12	067	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	642	NATIONAL BANK 	KERICHO	547700	12	068	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	643	NATIONAL BANK 	ISIOLO	547700	12	070	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	644	NATIONAL BANK 	SOUTH C - RED CROSS	547700	12	071	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	645	NATIONAL BANK 	NATIONAL BANK 	547700	12	072	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	646	NATIONAL BANK 	YAYA CENTRE	547700	12	073	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	647	NATIONAL BANK 	GIGIRI	547700	12	074	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	648	NATIONAL BANK 	WAJIR	547700	12	093	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	649	NATIONAL BANK 	BONDENI	547700	12	094	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	650	NATIONAL BANK 	LUNGA LUNGA	547700	12	095	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	651	NATIONAL BANK 	MANDERA CONVENTIONAL	547700	12	096	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	652	NATIONAL BANK 	CARD CENTRE	547700	12	098	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	653	NATIONAL BANK 	HEAD OFFICE	547700	12	099	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	654	NATIONAL BANK 	Central CLearing Centre	547700	12	198	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	655	NATIONAL BANK 	HEAD OFFICE AMANAH	547700	12	200	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	656	NATIONAL BANK 	CARD CENTRE AMANAH	547700	12	201	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	657	NATIONAL BANK 	EASTLEIGH AMANAH	547700	12	202	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	658	NATIONAL BANK 	KENYATTA AVENUE AMANAH	547700	12	203	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	659	NATIONAL BANK 	WAJIR AMANAH	547700	12	204	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	660	NATIONAL BANK 	BONDENI AMANAH	547700	12	205	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	661	NATIONAL BANK 	GARISSA AMANAH	547700	12	206	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	662	NATIONAL BANK 	MANDERA AMANAH	547700	12	207	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	663	NATIONAL BANK 	Isiolo Amanah	547700	12	208	NBKEKENX	40412000	PI/SAF	B0011	ACTIVE	0
1583931337	\N	1583931337	\N	664	M-ORIENTAL BANK LIMITED	HEAD OFFICE	986500	14	000	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	665	M-ORIENTAL BANK LIMITED	Koinange Street	986500	14	001	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	666	M-ORIENTAL BANK LIMITED	NAKURU BRANCH	986500	14	003	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	667	M-ORIENTAL BANK LIMITED	NAKURU BRANCH	986500	14	004	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	668	M-ORIENTAL BANK LIMITED	ELDORET BRANCH	986500	14	005	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	669	M-ORIENTAL BANK LIMITED	KITALE BRANCH	986500	14	006	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	670	M-ORIENTAL BANK LIMITED	WESTLANDS BRANCH	986500	14	007	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	671	M-ORIENTAL BANK LIMITED	NAKUMATT MEGA	986500	14	008	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	672	M-ORIENTAL BANK LIMITED	THIKA ROAD MALL	986500	14	009	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	673	M-ORIENTAL BANK LIMITED	MOMBASA	986500	14	010	DELFKENA	40414000	PI/SAF	B0012	ACTIVE	0
1583931337	\N	1583931337	\N	674	CITIBANK	Head Office	100229	16	000	CITIKENA	40416000	PI/SAF	B0013	ACTIVE	0
1583931337	\N	1583931337	\N	675	CITIBANK	MOMBASA BRANCH	100229	16	400	CITIKENA	40416000	PI/SAF	B0013	ACTIVE	0
1583931337	\N	1583931337	\N	676	CITIBANK	GIGIRI AGENCY	100229	16	500	CITIKENA	40416000	PI/SAF	B0013	ACTIVE	0
1583931337	\N	1583931337	\N	677	CITIBANK	KISUMU	100229	16	700	CITIKENA	40416000	PI/SAF	B0013	ACTIVE	0
1583931337	\N	1583931337	\N	678	HABIB BANK A.G.ZURICH	Head Office	\N	17	000	HBZUKENA	40417000	Pesalink	B0014	ACTIVE	0
1583931337	\N	1583931337	\N	679	HABIB BANK A.G.ZURICH	MOMBASA BRANCH	\N	17	001	HBZUKENA	40417000	Pesalink	B0014	ACTIVE	0
1583931337	\N	1583931337	\N	680	HABIB BANK A.G.ZURICH	INDUSTRIAL AREA	\N	17	002	HBZUKENA	40417000	Pesalink	B0014	ACTIVE	0
1583931337	\N	1583931337	\N	681	HABIB BANK A.G.ZURICH	WESTLANDS	\N	17	003	HBZUKENA	40417000	Pesalink	B0014	ACTIVE	0
1583931337	\N	1583931337	\N	682	HABIB BANK A.G.ZURICH	NYALI	\N	17	004	HBZUKENA	40417000	Pesalink	B0014	ACTIVE	0
1583931337	\N	1583931337	\N	683	MIDDLE EAST BANK	HEAD OFFICE NAIROBI	839900	18	000	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	684	MIDDLE EAST BANK	NAIROBI	839900	18	001	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	685	MIDDLE EAST BANK	MOMBASA	839900	18	002	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	686	MIDDLE EAST BANK 	MILIMANI RD NAIROBI	839900	18	003	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	687	MIDDLEEAST BANK 	INDUSTRIAL AREA	839900	18	004	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	688	MIDDLE EAST BANK	ELDORET	839900	18	005	MIEKKENA	40418000	PI/SAF	B0015	ACTIVE	0
1583931337	\N	1583931337	\N	689	BANK OF AFRICA	Reinsurance Plaza Nairobi	972900	19	000	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	690	BANK OF AFRICA	MOMBASA BRANCH	972900	19	001	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	691	BANK OF AFRICA	WESTLANDS BRANCH	972900	19	002	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	692	BANK OF AFRICA	UHURU HIGHWAY BRANCH	972900	19	003	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	693	BANK OF AFRICA	RIVER ROAD	972900	19	004	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	694	BANK OF AFRICA	THIKA	972900	19	005	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	695	BANK OF AFRICA	KISUMU	972900	19	006	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	696	BANK OF AFRICA	Ruaraka	972900	19	007	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	697	BANK OF AFRICA	MONROVIA STREET	972900	19	008	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	698	BANK OF AFRICA	NAKURU	972900	19	009	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	699	BANK OF AFRICA	NGONG ROAD BRANCH	972900	19	010	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	700	BANK OF AFRICA	ELDORET	972900	19	011	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	701	BANK OF AFRICA	EMBAKASI BRANCH	972900	19	012	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	702	BANK OF AFRICA	KERICHO	972900	19	013	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	703	BANK OF AFRICA	ONGATA RONGAI	972900	19	014	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	704	BANK OF AFRICA	CHANGAMWE	972900	19	015	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	705	BANK OF AFRICA	BUNGOMA	972900	19	016	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	706	BANK OF AFRICA	KISII BRANCH	972900	19	017	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	707	BANK OF AFRICA	MERU	972900	19	018	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	708	BANK OF AFRICA	KITENGELA	972900	19	019	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	709	BANK OF AFRICA	NYALI	972900	19	020	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	710	BANK OF AFRICA	GALLERIA	972900	19	021	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	711	BANK OF AFRICA	GREENSPAN MALL	972900	19	022	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	712	BANK OF AFRICA	UPPER HILL	972900	19	023	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	713	BANK OF AFRICA	NANYUKI	972900	19	024	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	714	BANK OF AFRICA	LUNGA LUNGA BRANCH	972900	19	025	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	715	BANK OF AFRICA	KENYATTA AVENUE	972900	19	026	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	716	BANK OF AFRICA	SAMEER BUSINESS PARK	972900	19	027	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	717	BANK OF AFRICA	Moi Avenue	972900	19	028	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	718	BANK OF AFRICA	ONGATA RONGAI II	972900	19	029	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	719	BANK OF AFRICA	GIKOMBA	972900	19	030	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	720	BANK OF AFRICA	GITHURAI	972900	19	031	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	721	BANK OF AFRICA	EMBU	972900	19	032	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	722	BANK OF AFRICA	GATEWAY MALL	972900	19	033	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	723	BANK OF AFRICA	Kitale	972900	19	034	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	724	BANK OF AFRICA	SOUTH B	972900	19	035	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	725	BANK OF AFRICA	DIGO ROAD	972900	19	036	AFRIKENX	40419000	PI/SAF	B0016	ACTIVE	0
1583931337	\N	1583931337	\N	726	CONSOLIDATED BANK	HARAMBEE AVENUE	508400	23	000	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	727	CONSOLIDATED BANK	MURANGA	508400	23	001	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	728	CONSOLIDATED BANK	EMBU	508400	23	002	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	729	CONSOLIDATED BANK	MOMBASA	508400	23	003	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	730	CONSOLIDATED BANK	KOINANGE STREET	508400	23	004	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	731	CONSOLIDATED BANK	THIKA	508400	23	005	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	732	CONSOLIDATED BANK	MERU	508400	23	006	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	733	CONSOLIDATED BANK	NYERI	508400	23	007	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	734	CONSOLIDATED BANK	Laare	508400	23	008	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	735	CONSOLIDATED BANK	MAUA	508400	23	009	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	736	CONSOLIDATED BANK	ISIOLO	508400	23	010	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	737	CONSOLIDATED BANK	HEAD OFFICE KOINANGE	508400	23	011	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	738	CONSOLIDATED BANK	CORPORATE	508400	23	012	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	739	CONSOLIDATED BANK	Umoja	508400	23	013	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	740	CONSOLIDATED BANK	RIVER ROAD	508400	23	014	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	741	CONSOLIDATED BANK	ELDORET BRANCH	508400	23	015	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	742	CONSOLIDATED BANK	NAKURU BRANCH	508400	23	016	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	743	CONSOLIDATED BANK	KITENGELA	508400	23	017	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	744	CONSOLIDATED BANK	TAJ MALL	508400	23	018	CONKKENA	40423000	PI/SAF	B0017	ACTIVE	0
1583931337	\N	1583931337	\N	745	CREDIT BANK 	HEAD OFFICE	972700	25	000	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	746	CREDIT BANK 	KOINANGE STREET	972700	25	001	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	747	CREDIT BANK 	KISUMU BRANCH	972700	25	002	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	748	CREDIT BANK 	NAKURU BRANCH	972700	25	003	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	749	CREDIT BANK 	KISII BRANCH	972700	25	004	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	750	CREDIT BANK	WESTLANDS BRANCH	972700	25	005	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	751	CREDIT BANK 	INDUSTRIAL AREA	972700	25	006	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	752	CREDIT BANK 	NAKURU KENYATTA AVENUE	972700	25	008	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	753	CREDIT BANK 	ELDORET BRANCH	972700	25	009	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	754	CREDIT BANK	RONGAI	972700	25	010	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	755	CREDIT BANK 	MOMBASA NYALI CENTRE	972700	25	011	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	756	CREDIT BANK	THIKA BRANCH	972700	25	012	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	757	CREDIT BANK 	LAVINGTON MALL	972700	25	013	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	758	CREDIT BANK 	MACHAKOS	972700	25	014	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	759	CREDIT BANK 	KITENGELA	972700	25	015	CRBTKENA	40425000	PI/SAF	B0018	ACTIVE	0
1583931337	\N	1583931337	\N	760	TRANSNATIONAL BANK 	Head Office	862862	26	001	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	761	TRANSNATIONAL BANK 	MOMBASA	862862	26	002	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	762	TRANSNATIONAL BANK 	ELDORET	862862	26	003	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	763	TRANSNATIONAL BANK 	NAKURU	862862	26	004	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	764	TRANSNATIONAL BANK 	MOI INTERNATIONAL AIRPORT	862862	26	005	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	765	TRANSNATIONAL BANK 	JOMO KENYATTA INTERNATIONAL AIRPOR	862862	26	006	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	766	TRANSNATIONAL BANK 	Kirinyaga Rd Nakuru	862862	26	007	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	767	TRANSNATIONAL BANK 	KABARAK UNIVERSITY BRANCH	862862	26	008	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	768	TRANSNATIONAL BANK 	Olenguruone	862862	26	009	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	769	TRANSNATIONAL BANK 	NANDI HILLS BRANCH	862862	26	011	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	770	TRANSNATIONAL BANK 	EPZ BRANCH ATHI RIVER	862862	26	012	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	771	TRANS-NATIONAL BANK	Nandi Hills	862862	26	013	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	772	TRANS NATIONAL BANK	KABARNET BRANCH	862862	26	014	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	773	TRANSNATIONAL BANK 	KITALE	862862	26	015	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	774	TRANSNATIONAL BANK	NAROK	862862	26	016	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	775	TRANS-NATIONAL BANK 	BOMET	862862	26	017	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	776	TRANS-NATIONAL BANK 	ITEN	862862	26	018	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	777	TRANS-NATIONAL BANK 	LESSOS	862862	26	019	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	778	TRANSNATIONAL BANK 	FLAX	862862	26	020	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	779	TRANSNATIONAL BANK 	KIPTAGICH	862862	26	023	TNBLKENA	\N	PI/SAF	B0019	ACTIVE	0
1583931337	\N	1583931337	\N	780	SBM BANK 	Head Office	552800	30	000	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	781	SBM BANK 	CITY CENTRE BRANCH	552800	30	001	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	782	SBM BANK	VILLAGE MARKET	552800	30	003	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	783	SBM BANK	MOMBASA BRANCH	552800	30	004	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	784	SBM BANK	EASTLEIGH BRANCH	552800	30	006	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	785	SBM BANK 	PARKLANDS BRANCH	552800	30	007	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	786	SBM BANK 	RIVERSIDE MEWS BRANCH	552800	30	008	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	787	SBM BANK	IMAN BANKING CENTRE	552800	30	009	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	788	SBM BANK	THIKA	552800	30	010	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	789	SBM BANK 	NAKURU BRANCH	552800	30	011	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	790	SBM BANK	DONHOLM	552800	30	012	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	791	SBM BANK 	BONDENI CHASE IMAN	552800	30	013	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	792	SBM BANK 	NGARA BRANCH	552800	30	014	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	793	SBM BANK 	KISUMU	552800	30	015	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	794	SBM BANK	ELDORET	552800	30	016	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	795	SBM BANK 	DIAMOND PLAZA	552800	30	017	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	796	SBM BANK 	WINDSOR	552800	30	018	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	797	SBM BANK 	MALINDI	552800	30	019	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	798	SBM BANK 	EMBAKASI	552800	30	020	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	799	SBM BANK 	UPPERHILL	552800	30	021	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	800	SBM BANK 	NYALI	552800	30	022	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	801	SBM BANK 	BURUBURU	552800	30	023	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	802	SBM BANK 	STRATHMORE	552800	30	024	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	803	SBM BANK 	KISII	552800	30	025	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	804	SBM BANK 	VIRTUAL	552800	30	026	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	805	SBM BANK 	RAFIKI DTM CLEARING CENTER	552800	30	027	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	806	SBM BANK 	CHASE XPRESS - NGONG ROAD	552800	30	028	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	807	SBM BANK 	CHASE ELITE ABC PLACE	552800	30	029	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	808	SBM BANK 	SAMEER BUSINESS PARK	552800	30	030	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	809	SBM BANK 	MTWAPA	552800	30	031	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	810	SBM BANK	ONGATA RONGAI	552800	30	032	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	811	SBM BANK 	WESTLANDS	552800	30	033	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	812	SBM BANK 	Machakos	552800	30	034	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	813	SBM BANK 	Mombasa Old Town	552800	30	035	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	814	SBM BANK 	River Road	552800	30	036	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	815	SBM BANK 	LUNGA LUNGA ROAD	552800	30	037	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	816	SBM BANK 	Chase Xpress Dagoretti Corner	552800	30	038	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	817	SBM BANK 	CHASE EXPRESS MADARAKA CORNER	552800	30	039	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	818	SBM BANK 	KITALE	552800	30	040	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	819	SBM BANK 	KIMATHI	552800	30	041	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	820	SBM BANK 	NAROK	552800	30	042	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	821	SBM BANK 	SACCO PROCESSING CENTRE	552800	30	043	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	822	SBM BANK 	GARISSA	552800	30	044	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	823	SBM BANK 	KPA	552800	30	045	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	824	SBM BANK 	LAVINGTON	552800	30	046	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	825	SBM BANK 	KERICHO	552800	30	047	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	826	SBM BANK 	KAREN	552800	30	048	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	827	SBM BANK 	KILIMANI	552800	30	049	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	828	SBM BANK 	KASUKU CENTRE	552800	30	050	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	829	SBM BANK 	KILIFI	552800	30	051	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	830	SBM BANK 	KISUMU NIVAS	552800	30	052	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	831	SBM BANK 	RUAKA	552800	30	053	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	832	SBM BANK 	GARDEN CITY	552800	30	054	FCBLKENA	40430000	PI/SAF	B0020	ACTIVE	0
1583931337	\N	1583931337	\N	833	STANBIC BANK KENYA LIMITED	Head Office	600100	31	000	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	834	STANBIC BANK KENYA LIMITED	Kenyatta Ave	600100	31	002	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	835	STANBIC BANK KENYA LIMITED	DIGO ROAD	600100	31	003	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	836	STANBIC BANK KENYA LIMITED	WAIYAKI WAY	600100	31	004	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	837	STANBIC BANK KENYA LIMITED	INDUSTRIAL AREA	600100	31	005	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	838	STANBIC BANK KENYA LIMITED	HARAMBEE AVENUE	600100	31	006	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	839	STANBIC BANK KENYA LIMITED	CHIROMO ROAD BRANCH	600100	31	007	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	840	STANBIC BANK KENYA LIMITED	INTERNATIONAL HSE	600100	31	008	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	841	STANBIC BANK KENYA LIMITED	UPPERHILL	600100	31	010	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	842	STANBIC BANK KENYA LIMITED	NAIVASHA	600100	31	011	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	843	STANBIC BANK KENYA LIMITED	WESTGATE	600100	31	012	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	844	STANBIC BANK KENYA LIMITED	KISUMU	600100	31	013	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	845	STANBIC BANK KENYA LIMITED	NAKURU	600100	31	014	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	846	STANBIC BANK KENYA LIMITED	THIKA BRANCH	600100	31	015	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	847	STANBIC BANK KENYA LIMITED	NANYUKI	600100	31	017	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	848	STANBIC BANK KENYA LIMITED	MERU	600100	31	018	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	849	STANBIC BANK KENYA LIMITED	BURUBURU	600100	31	019	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	850	STANBIC BANK KENYA LIMITED	GIKOMBA	600100	31	020	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	851	STANBIC BANK KENYA LIMITED	GARDEN CITY	600100	31	021	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	852	STANBIC BANK KENYA LIMITED	ELDORET KORIAMATT UGANDA ROAD	600100	31	022	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	853	STANBIC BANK KENYA LIMITED	KAREN	600100	31	023	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	854	STANBIC BANK KENYA LIMITED	KISII BRANCH	600100	31	024	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	855	STANBIC BANK KENYA LIMITED	WARWICK	600100	31	025	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	856	STANBIC BANK KENYA LIMITED	PRIVATE CLIENTS	600100	31	026	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	857	STANBIC BANK KENYA LIMITED	NYALI	600100	31	027	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	858	STANBIC BANK KENYA LIMITED	MALINDI	600100	31	028	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	859	STANBIC BANK KENYA LIMITED	Central Processing H/O	600100	31	999	SBICKENX	40431000	PI/SAF	B0021	ACTIVE	0
1583931337	\N	1583931337	\N	860	AFRICAN BANKING CORP	Koinange Street	111777	35	000	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	861	AFRICAN BANKING CORP	Nkrumah Road Mombasa	111777	35	003	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	862	AFRICAN BANKING CORP	ELDORET	111777	35	005	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	863	AFRICAN BANKING CORP	MERU	111777	35	006	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	864	AFRICAN BANKING CORP	LIBRA HOUSE	111777	35	007	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	865	AFRICAN BANKING CORP	NAKURU	111777	35	008	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	866	AFRICAN BANKING CORP	LAMU	111777	35	009	ABCLKENA	40435000	PI/SAF	B0022	ACTIVE	0
1583931337	\N	1583931337	\N	867	NIC-BANK	HEAD OFFICE BRANCH	488488	41	000	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	868	NIC-BANK	City Centre	488488	41	101	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	869	NIC-BANK	NIC HOUSE	488488	41	102	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	870	NIC-BANK	Harbour House	488488	41	103	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	871	NIC-BANK	HEAD OFFICE- FARGO	488488	41	104	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	872	NIC-BANK	The Mall	488488	41	105	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	873	NIC-BANK	THE JUNCTION BRANCH	488488	41	106	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	874	NIC-BANK	NAKURU BRANCH	488488	41	107	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	875	NIC-BANK	NYALI BRANCH	488488	41	108	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	876	NIC-BANK	NKRUMAH ROAD BRANCH	488488	41	109	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	877	NIC-BANK	HARAMBEE AVENUE	488488	41	110	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	878	NIC-BANK	PRESTIGE - NGONG ROAD	488488	41	111	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	879	NIC-BANK	KISUMU	488488	41	112	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	880	NIC BANK	THIKA	488488	41	113	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	881	NIC BANK	NJURI NCHEKE STREET	488488	41	114	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	882	NIC-BANK	GALLERIA(BOMAS) BRANCH	488488	41	115	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	883	NIC-BANK	ELDORET	488488	41	116	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	884	NIC-BANK	VILLAGE MARKET	488488	41	117	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	885	NIC BANK	SAMEER PARK	488488	41	118	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	886	NIC-BANK	KAREN	488488	41	119	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	887	NIC-BANK	TAJ MALL	488488	41	121	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	888	NIC BANK	ABC	488488	41	122	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	889	NIC-BANK	THIKA ROAD MALL	488488	41	123	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	890	NIC-BANK	CHANGAMWE	488488	41	124	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	891	NIC-BANK	KENYATTA AVENUE	488488	41	125	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	892	NIC-BANK	RIVERSIDE	488488	41	126	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	893	NIC-BANK	Machakos	488488	41	127	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	894	NIC-BANK	LUNGA LUNGA SQUARE	488488	41	128	NINCKENA	40441000	PI/SAF	B0023	ACTIVE	0
1583931337	\N	1583931337	\N	895	GIRO BANK LTD / COMMERCE BANK	Banda	\N	42	000	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	896	GIRO BANK LTD / COMMERCE BANK	MOMBASA	\N	42	001	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	897	GIRO BANK LTD / COMMERCE BANK	INDUSTRIAL AREA	\N	42	002	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	898	GIRO BANK LTD / COMMERCE BANK	KIMATHI STREET	\N	42	003	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	899	GIRO BANK LTD / COMMERCE BANK	KISUMU	\N	42	004	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	900	GIRO BANK LTD / COMMERCE BANK	WESTLANDS	\N	42	005	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	901	GIRO BANK	Parklands 3rd Avenue	\N	42	007	GIROKENX	40442000	Pesalink	B0024	ACTIVE	0
1583931337	\N	1583931337	\N	902	ECOBANK	NAIROBI	700201	43	000	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	903	ECOBANK	MOI AVE NBI.	700201	43	001	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	904	ECOBANK	Akiba Hse Mombasa	700201	43	002	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	905	ECOBANK	Plaza 2000	700201	43	003	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	906	ECOBANK	Westminister	700201	43	004	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	907	ECOBANK	Chambers	700201	43	005	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	908	ECOBANK	THIKA	700201	43	006	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	909	ECOBANK	ELDORET	700201	43	007	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	910	ECOBANK	KISUMU	700201	43	008	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	911	ECO BANK	KISII	700201	43	009	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	912	ECO BANK	KITALE	700201	43	010	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	913	ECOBANK	NAIROBI	700201	43	011	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	914	ECOBANK	KARATINA	700201	43	012	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	915	ECOBANK	WESTLANDS - 43013	700201	43	013	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	916	ECOBANK	UNITED MALL - 43014	700201	43	014	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	917	ECOBANK	NAKURU - 43015	700201	43	015	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	918	ECO BANK	JOMO KENYATTA AVENUE	700201	43	016	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	919	ECO BANK	GAKERE ROAD	700201	43	017	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	920	ECOBANK	BUSIA	700201	43	018	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	921	ECOBANK	MALINDI	700201	43	019	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	922	ECOBANK	MERU	700201	43	020	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	923	ECOBANK	GIKOMBA	700201	43	021	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	924	ECOBANK	UPPERHILL	700201	43	022	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	925	ECOBANK	VALLEY ARCADE-GITANGA ROAD	700201	43	023	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	926	ECOBANK	KAREN BRANCH	700201	43	024	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	927	ECOBANK	NYALI MOMBASA	700201	43	025	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	928	ECOBANK	ONGATA RONGAI	700201	43	026	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	929	ECOBANK	EMBAKASI	700201	43	027	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	930	ECOBANK	KITENGELA	700201	43	028	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	931	ECOBANK	43029	700201	43	029	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	932	ECOBANK	Head Office	700201	43	100	ECOCKENA	40443000	PI/SAF	B0025	ACTIVE	0
1583931337	\N	1583931337	\N	933	SPIRE BANK LTD	NAIROBI HEAD OFFICE	498100	49	000	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	934	SPIRE BANK LTD	NYERERE ROAD BRANCH	498100	49	001	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	935	SPIRE BANK LTD	MOMBASA	498100	49	002	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	936	SPIRE BANK LTD	WESTLANDS - THE MALL	498100	49	003	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	937	SPIRE BANK LTD	MOMBASA ROAD	498100	49	004	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	938	SPIRE BANK LTD	CHESTER BRANCH	498100	49	005	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	939	SPIRE BANK LTD	WAIYAKI WAY BRANCH	498100	49	007	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	940	SPIRE BANK LTD	KAKAMEGA BRANCH	498100	49	008	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	941	SPIRE BANK LTD	ELDORET BRANCH	498100	49	009	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	942	SPIRE BANK LTD	SENATOR CARDS	498100	49	010	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	943	SPIRE BANK LTD	NYALI BRANCH	498100	49	011	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	944	SPIRE BANK LTD	KISUMU BRANCH	498100	49	012	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	945	SPIRE BANK LTD	INDUSTRIAL AREA BRANCH	498100	49	013	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	946	SPIRE BANK LTD	NAKURU	498100	49	015	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	947	SPIRE BANK LTD	Ongata Rongai	498100	49	016	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	948	SPIRE BANK LTD	MACHAKOS	498100	49	017	SPBLKENA	40449000	PI/SAF	B0026	ACTIVE	0
1583931337	\N	1583931337	\N	949	PARAMOUNT UNIVERSAL BANK LTD	HEAD OFFICE	907950	50	000	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	950	PARAMOUNT UNIVERSAL BANK LTD	WESTLANDS	907950	50	001	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	951	PARAMOUNT UNIVERSAL BANK LTD	PARKLANDS	907950	50	002	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	952	PARAMOUNT UNIVERSAL BANK LTD	Koinange Street	907950	50	003	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	953	PARAMOUNT UNIVERSAL BANK LTD	MOMBASA	907950	50	004	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	954	PARAMOUNT UNIVERSAL BANK LTD	ELDORET	907950	50	006	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	955	PARAMOUNT UNIVERSAL BANK LTD	Industrial Area	907950	50	007	PAUTKENA	40450000	PI/SAF	B0027	ACTIVE	0
1583931337	\N	1583931337	\N	956	JAMII BORA BANK	HEAD OFFICE	529901	51	000	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	957	JAMII BORA BANK	KOINANGE STREET	529901	51	001	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	958	JAMII BORA BANK	KIONGOZI	529901	51	100	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	959	JAMII BORA BANK	KAYOLE	529901	51	101	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	960	JAMII BORA BANK	MATHARE	529901	51	102	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	961	JAMII BORA BANK	KAWANGWARE	529901	51	105	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	962	JAMII BORA BANK	KIBERA	529901	51	106	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	963	JAMII BORA BANK	KARIOBANGI	529901	51	107	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	964	JAMII BORA BANK	CENTRAL CLEARING CENTER	529901	51	111	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	965	JAMII BORA BANK	FUNZI ROAD	529901	51	114	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	966	JAMII BORA BANK	NGONG ROAD	529901	51	115	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	967	JAMII BORA BANK	KIRINYAGA ROAD	529901	51	116	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	968	JAMII BORA BANK	MACHAKOS	529901	51	209	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	969	JAMII BORA BANK	MTWAPA	529901	51	210	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	970	JAMII BORA BANK	KIRITIRI	529901	51	213	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	971	JAMII BORA BANK	THIKA	529901	51	301	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	972	JAMII BORA BANK	MURANGA	529901	51	303	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	973	JAMII BORA BANK	WANGIGE	529901	51	305	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	974	JAMII BORA BANK	KIKUYU	529901	51	306	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	975	JAMII BORA BANK	BANANA	529901	51	307	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	976	JAMII BORA BANK	KIAMBU	529901	51	308	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	977	JAMII BORA BANK	UTAWALA	529901	51	310	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	978	JAMII BORA BANK	NYERI	529901	51	316	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	979	JAMII BORA BANK	KISUMU	529901	51	402	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	980	JAMII BORA BANK	ONGATA RONGAI	529901	51	502	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	981	JAMII BORA BANK	KITENGELA	529901	51	503	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	982	JAMII BORA BANK	NAKURU	529901	51	507	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	983	JAMII BORA BANK	MOMBASA BRANCH	529901	51	603	CIFIKENA	40451000	PI/SAF	B0028	ACTIVE	0
1583931337	\N	1583931337	\N	984	GUARANTY TRUST BANK (KENYA) LTD	HEAD OFFICE	910200	53	000	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	985	GUARANTY TRUST BANK (KENYA) LTD	Kimathi Str	910200	53	001	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	986	GUARANTY TRUST BANK (KENYA) LTD	INDUSTRIAL AREA	910200	53	002	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	987	GUARANTY TRUST BANK (KENYA) LTD	WESTLANDS UKAY CENTRE	910200	53	003	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	988	GUARANTY TRUST BANK (KENYA) LTD	LAVINGTON ABC PLACE	910200	53	004	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	989	GUARANTY TRUST BANK (KENYA) LTD	Nkrumah Road	910200	53	005	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	990	GUARANTY TRUST BANK (KENYA) LTD	NAKURU BRANCH	910200	53	006	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	991	GUARANTY TRUST BANK (KENYA) LTD	ELDORET BRANCH	910200	53	007	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	992	GUARANTY TRUST BANK (KENYA) LTD	MUTHAIGA	910200	53	008	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	993	GUARANTY TRUST BANK (KENYA) LTD	NANYUKI	910200	53	009	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	994	GUARANTY TRUST BANK (KENYA) LTD	THIKA	910200	53	010	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	995	GUARANTY TRUST BANK (KENYA) LTD	GIKOMBA	910200	53	011	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	996	GUARANTY TRUST BANK (KENYA) LTD	NGONG ROAD	910200	53	012	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	997	GUARANTY TRUST BANK (KENYA) LTD	MERU TOWN CTR	910200	53	013	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	998	GUARANTY TRUST BANK (KENYA) LTD	NYALI	910200	53	014	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	999	GUARANTY TRUST BANK (KENYA) LTD	SKY PARK	910200	53	015	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	1000	GUARANTY TRUST BANK (KENYA) LTD	KAREN	910200	53	016	GTBIKENA	40453000	PI/SAF	B0029	ACTIVE	0
1583931337	\N	1583931337	\N	1001	VICTORIA COMMERCIAL BANK LTD	Victoria Towers	842100	54	001	VICMKENA	40454000	PI/SAF	B0030	ACTIVE	0
1583931337	\N	1583931337	\N	1002	VICTORIA COMMERCIAL BANK LTD	RIVERSIDE DRIVE BRANCH	842100	54	002	VICMKENA	40454000	PI/SAF	B0030	ACTIVE	0
1583931337	\N	1583931337	\N	1003	VICTORIA COMMERCIAL BANK LTD	LUNGA LUNGA SQUARE	842100	54	003	VICMKENA	40454000	PI/SAF	B0030	ACTIVE	0
1583931337	\N	1583931337	\N	1004	GUARDIAN BANK LTD	Head Office	344500	55	001	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1005	GUARDIAN BANK LTD	WESTLANDS	344500	55	002	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1006	GUARDIAN BANK LTD	Mombasa	344500	55	003	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1007	GUARDIAN BANK LTD	UGANDA RD	344500	55	004	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1008	GUARDIAN BANK LTD	KISUMU	344500	55	005	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1009	GUARDIAN BANK LTD	GUIDERS CENTRE MOI AVE	344500	55	006	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1010	GUARDIAN BANK LTD	MOMBASA ROAD	344500	55	007	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1011	GUARDIAN BANK LTD	NYALI	344500	55	008	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1012	GUARDIAN BANK LTD	NGONG ROAD	344500	55	009	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1013	GUARDIAN BANK LTD	NAKURU	344500	55	010	GUARKENA	40455000	PI/SAF	B0031	ACTIVE	0
1583931337	\N	1583931337	\N	1014	I & M BANK LTD	HEAD OFFICE / KENYATTA AVE. NAIR	542542	57	000	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1015	I & M BANK LTD	2ND NGONG AVE. NAIROBI	542542	57	001	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1016	I & M BANK LTD	SARIT CENTRE WESTLANDS	542542	57	002	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1017	I & M BANK LTD	HEAD OFFICE	542542	57	003	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1018	I & M BANK LTD	BIASHARA STREET	542542	57	004	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1019	I & M BANK LTD	MOMBASA BRANCH	542542	57	005	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1020	I & M BANK LTD	INDUSTRIAL AREA BRANCH	542542	57	006	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1021	I & M BANK LTD	KISUMU BRANCH	542542	57	007	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1022	I & M BANK LTD	KAREN CONNECTION KAREN ROAD	542542	57	008	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1023	I & M BANK LTD	PANARI CENTRE	542542	57	009	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1024	I & M BANK LTD	PARKLANDS BRANCH	542542	57	010	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1025	I & M BANK LTD	WILSON AIRPORT	542542	57	011	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1026	I & M BANK LTD	ONGATA RONGAI	542542	57	012	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1027	I & M BANK LTD	SOUTH C SHOPPING CENTER	542542	57	013	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1028	I & M BANK LTD	NYALI CINEMAX	542542	57	014	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1029	I & M BANK LTD	LANGATA LINK	542542	57	015	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1030	I & M BANK LTD	LAVINGTON BRANCH	542542	57	016	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1031	I & M BANK LTD	ELDORET	542542	57	017	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1032	I & M BANK LTD	NAKURU BRANCH	542542	57	018	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1033	I & M BANK LTD	RIVERSIDE DRIVE BRANCH	542542	57	019	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1034	I & M BANK LTD	KISII	542542	57	020	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1035	I & M BANK LTD	CHANGAMWE	542542	57	021	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1036	I & M BANK LTD	MALINDI	542542	57	022	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1037	I & M BANK LTD	NYERI	542542	57	023	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1038	I & M BANK LTD	THIKA	542542	57	024	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1039	I & M BANK LTD	GIGIRI	542542	57	025	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1040	I & M BANK LTD	MTWAPA	542542	57	026	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1041	I & M BANK LTD	LAVINGTON MALL	542542	57	027	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1042	I & M BANK LTD	KITALE	542542	57	028	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1043	I & M BANK LTD	LUNGA LUNGA	542542	57	029	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1044	I & M BANK LTD	YAYA CENTRE	542542	57	030	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1045	I & M BANK LTD	GATEWAY MALL	542542	57	031	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1046	I & M BANK LTD	CARD CENTRE	542542	57	098	IMBLKENA	40457000	PI/SAF	B0032	ACTIVE	0
1583931337	\N	1583931337	\N	1047	DEVELOPMENT BANK OF KENYA	HEAD OFFICE NAIROBI	\N	59	000	DEVKKENA	40459000	Pesalink	B0033	ACTIVE	0
1583931337	\N	1583931337	\N	1048	DEVELOPMENT BANK OF KENYA	LOITA STREET NAIROBI	\N	59	001	DEVKKENA	40459000	Pesalink	B0033	ACTIVE	0
1583931337	\N	1583931337	\N	1049	FIDELITY COMMERCIAL BANK	HEAD OFFICE	\N	60	000	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1050	FIDELITY COMMERCIAL BANK	CITY CENTRE BRANCH	\N	60	001	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1051	FIDELITY COMMERCIAL BANK	Westlands Branch	\N	60	002	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1052	FIDELITY COMMERCIAL BANK	INDUSTRIAL AREA	\N	60	003	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1053	FIDELITY COMMERCIAL BANK	DIANI BRANCH	\N	60	004	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1054	FIDELITY COMMERCIAL BANK	MALINDI BRANCH	\N	60	005	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1055	FIDELITY COMMERCIAL BANK	MOMBASA	\N	60	006	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1056	FIDELITY COMMERCIAL BANK	CHANGAMWE	\N	60	007	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1057	FIDELITY COMMERCIAL BANK	KILIMANI	\N	60	008	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1058	FIDELITY COMMERCIAL BANK	NEW MUTHAIGA BRANCH	\N	60	009	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1059	FIDELITY COMMERCIAL BANK	NYALI	\N	60	010	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1060	FIDELITY COMMERCIAL BANK	SAMEER PARK	\N	60	011	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1061	FIDELITY COMMERCIAL BANK	HIGHRIDGE	\N	60	012	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1062	FIDELITY COMMERCIAL BANK	GARDEN CITY	\N	60	013	FCBLKENA	40460000	Pesalink	B0034	ACTIVE	0
1583931337	\N	1583931337	\N	1063	HOUSING FINANCE CO. KENYA	KITENGELA	100400	61	016	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1064	HOUSING FINANCE CO. KENYA	NAIVASHA	100400	61	017	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1065	HOUSING FINANCE CO. KENYA	EMBU	100400	61	025	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1066	HOUSING FINANCE CO. KENYA	HEAD OFFICE	100400	61	100	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1067	HOUSING FINANCE CO. KENYA	REHANI HOUSE	100400	61	200	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1068	HOUSING FINANCE CO. KENYA	KENYATTA MARKET	100400	61	210	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1069	HOUSING FINANCE CO. KENYA	GILL HOUSE	100400	61	220	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1070	HOUSING FINANCE CO. KENYA	BURUBURU	100400	61	230	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1071	HOUSING FINANCE CO. KENYA	THIKA ROAD MALL	100400	61	260	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1072	HOUSING FINANCE CO. KENYA	SAMEER BUSINESS PARK	100400	61	270	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1073	HOUSING FINANCE CO. KENYA	\N	100400	61	280	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1074	HOUSING FINANCE CO. KENYA	MOMBASA	100400	61	300	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1075	HOUSING FINANCE CO. KENYA	NYALI	100400	61	310	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1076	HOUSING FINANCE CO. KENYA	NAKURU	100400	61	400	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1077	HOUSING FINANCE CO. KENYA	ELDORET	100400	61	410	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1078	HOUSING FINANCE CO. KENYA	THIKA	100400	61	500	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1079	HOUSING FINANCE CO. KENYA	NYERI	100400	61	510	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1080	HOUSING FINANCE CO. KENYA	MERU	100400	61	520	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1081	HOUSING FINANCE CO. KENYA	KISUMU	100400	61	600	HFCOKENA	\N	PI/SAF	B0035	ACTIVE	0
1583931337	\N	1583931337	\N	1082	DIAMOND TRUST BANK	NAIROBI HEAD OFFICE	516600	63	000	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1083	DIAMOND TRUST BANK	NATION CENTRE	516600	63	001	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1084	DIAMOND TRUST BANK	MOMBASA	516600	63	002	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1085	DIAMOND TRUST BANK	KISUMU	516600	63	003	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1086	DIAMOND TRUST BANK	Parklands	516600	63	005	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1087	DIAMOND TRUST BANK	WESTGATE BRANCH	516600	63	006	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1088	DIAMOND TRUST BANK	Mombasa Rd	516600	63	008	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1089	DIAMOND TRUST BANK	INDUSTRIAL AREA BRANCH	516600	63	009	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1090	DIAMOND TRUST BANK	KISII BRANCH	516600	63	010	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1091	DIAMOND TRUST BANK	MALINDI	516600	63	011	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1092	DIAMOND TRUST BANK	THIKA BRANCH	516600	63	012	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1093	DIAMOND TRUST BANK	OTC NAIROBI	516600	63	013	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1094	DIAMOND TRUST BANK	ELDORET	516600	63	014	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1095	DIAMOND TRUST BANK	EASTLEIGH	516600	63	015	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1096	DIAMOND TRUST BANK	CHANGAMWE	516600	63	016	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1097	DIAMOND TRUST BANK	T-MALL BRANCH	516600	63	017	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1098	DIAMOND TRUST BANK	NAKURU	516600	63	018	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1099	DIMOND TRUST BANK 	VILLAGE MARKET	516600	63	019	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1100	DIAMOND TRUST BANK	DIANI	516600	63	020	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1101	DIAMOND TRUST BANK	BUNGOMA	516600	63	021	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1102	DIAMOND TRUST BANK	KITALE	516600	63	022	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1103	DIAMOND TRUST BANK	PRESTIGE BRANCH	516600	63	023	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1104	DIAMOND TRUST BANK	BURUBURU	516600	63	024	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1105	DIAMOND TRUST BANK	KITENGELA	516600	63	025	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1106	DIAMOND TRUST BANK	JOMO KENYATTA	516600	63	026	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1107	DIAMOND TRUST BANK	KAKAMEGA	516600	63	027	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1108	DIAMOND TRUST BANK	KERICHO	516600	63	028	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1109	DIAMOND TRUST BANK	UPPER HILL	516600	63	029	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1110	DIAMOND TRUST BANK	WABERA STREET	516600	63	030	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1111	DIAMOND TRUST BANK	KAREN	516600	63	031	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1112	DIAMOND TRUST BANK	VOI	516600	63	032	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1113	DIAMOND TRUST BANK	SHIMANZI	516600	63	033	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1114	DIAMOND TRUST BANK	MERU	516600	63	034	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1115	DIAMOND TRUST BANK	DIAMOND PLAZA	516600	63	035	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1116	DIAMOND TRUST BANK	CROSSROADS NAIROBI	516600	63	036	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1117	DIAMOND TRUST BANK	JKIA BRANCH	516600	63	037	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1118	DIAMOND TRUST BANK	NYALI BRANCH	516600	63	038	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1119	DIAMOND TRUST BANK	MIGORI	516600	63	039	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1120	DIAMOND TRUST BANK	MADINA MALL	516600	63	040	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1121	DIAMOND TRUST BANK	COURTYARD	516600	63	041	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1122	DIAMOND TRUST BANK	MTWAPA	516600	63	042	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1123	DIAMOND TRUST BANK	LAMU	516600	63	043	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1124	DIAMOND TRUST BANK	KILIFI	516600	63	044	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1125	DIAMOND TRUST BANK	MARIAKANI	516600	63	045	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1126	DIAMOND TRUST BANK	THIKA ROAD MALL	516600	63	046	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1127	DIAMOND TRUST BANK	RONALD NGALA	516600	63	047	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1128	DIAMOND TRUST BANK	BUSIA	516600	63	048	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1129	DIAMOND TRUST BANK	DTB CENTRE	516600	63	049	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1130	DIAMOND TRUST BANK	TOM MBOYA ST	516600	63	050	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1131	DIAMOND TRUST BANK	DTB CENTRE	516600	63	052	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1132	DIAMOND TRUST BANK	SOUTH C	516600	63	053	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1133	DIAMOND TRUST BANK	LAVINGTON	516600	63	054	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1134	DIAMOND TRUST BANK	9 WEST	516600	63	055	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1135	DIAMOND TRUST BANK	BIASHARA ST. NAKURU	516600	63	056	DTKEKENA	40463000	PI/SAF	B0036	ACTIVE	0
1583931337	\N	1583931337	\N	1136	SIDIAN BANK	HEAD OFFICE	111999	66	000	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1137	SIDIAN BANK	MAIN OFFICE	111999	66	001	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1138	SIDIAN BANK	MOMBASA BRANCH	111999	66	002	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1139	SIDIAN BANK	KENYATTA AVENUE	111999	66	003	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1140	SIDIAN BANK	NAKURU	111999	66	004	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1141	SIDIAN BANK	NYERI	111999	66	005	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1142	SIDIAN BANK	BURUBURU	111999	66	006	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1143	SIDIAN BANK	EMBU	111999	66	007	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1144	SIDIAN BANK	ELDORET BRANCH	111999	66	008	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1145	SIDIAN BANK	KISUMU	111999	66	009	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1146	SIDIAN BANK	KERICHO	111999	66	010	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1147	SIDIAN BANK	MLOLONGO	111999	66	011	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1148	SIDIAN BANK	THIKA	111999	66	012	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1149	SIDIAN BANK	KERUGOYA	111999	66	013	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1150	SIDIAN BANK	KENYATTA MARKET	111999	66	014	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1151	SIDIAN BANK	KISII BRANCH	111999	66	015	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1152	SIDIAN BANK	CHUKA	111999	66	016	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1153	SIDIAN BANK	KITUI	111999	66	017	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1154	SIDIAN BANK	MACHAKOS BRANCH	111999	66	018	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1155	SIDIAN BANK	NANYUKI BRANCH	111999	66	019	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1156	SIDIAN BANK	KANGEMI	111999	66	020	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1157	SIDIAN BANK	EMALI	111999	66	021	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1158	SIDIAN BANK	NAIVASHA BRANCH	111999	66	022	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1159	SIDIAN BANK	NYAHURURU	111999	66	023	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1160	SIDIAN BANK	ISIOLO	111999	66	024	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1161	SIDIAN BANK	MERU	111999	66	025	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1162	SIDIAN BANK	KITALE	111999	66	026	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1163	SIDIAN BANK	KIBWEZI	111999	66	027	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1164	SIDIAN BANK	BUNGOMA	111999	66	028	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1165	SIDIAN BANK	KAJIADO	111999	66	029	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1166	SIDIAN BANK	NKUBU	111999	66	030	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1167	SIDIAN BANK	MTWAPA	111999	66	031	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1168	SIDIAN BANK	BUSIA	111999	66	032	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1169	SIDIAN BANK	Moi Nbi	111999	66	033	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1170	SIDIAN BANK	MWEA BRANCH	111999	66	034	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1171	SIDIAN BANK	KENGELENI BRANCH	111999	66	035	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1172	SIDIAN BANK	KILIMANI	111999	66	036	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1173	SIDIAN BANK	RONGAI	111999	66	037	SIDNKENA	40466000	PI/SAF	B0037	ACTIVE	0
1583931337	\N	1583931337	\N	1174	EQUITY BANK LIMITED	EQUITY BANK LIMITED	247247	68	000	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1175	EQUITY BANK LIMITED	EQUITY BANK LIMITED	247247	68	001	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1176	EQUITY BANK LIMITED	EQUITY BANK LIMITED	247247	68	002	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1177	EQUITY BANK LIMITED	KANGEMA	247247	68	003	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1178	EQUITY BANK LIMITED	KARATINA	247247	68	004	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1179	EQUITY BANK LIMITED	KIRIAINI	247247	68	005	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1180	EQUITY BANK LIMITED	MURARANDIA	247247	68	006	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1181	EQUITY BANK LIMITED	KANGARI	247247	68	007	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1182	EQUITY BANK LIMITED	OTHAYA	247247	68	008	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1183	EQUITY BANK LIMITED	Thika / Equity Plaza	247247	68	009	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1184	EQUITY BANK LIMITED	KERUGOYA	247247	68	010	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1185	EQUITY BANK LIMITED	NYERI	247247	68	011	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1186	EQUITY BANK LIMITED	TOM MBOYA	247247	68	012	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1187	EQUITY BANK LIMITED	NAKURU	247247	68	013	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1188	EQUITY BANK LIMITED	MERU	247247	68	014	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1189	EQUITY BANK LIMITED	MAMA NGINA	247247	68	015	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1190	EQUITY BANK LIMITED	NYAHURURU	247247	68	016	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1191	EQUITY BANK LIMITED	COMMUNITY	247247	68	017	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1192	EQUITY BANK LIMITED	COMMUNITY CORPORATE	247247	68	018	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1193	EQUITY BANK LIMITED	EMBU	247247	68	019	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1194	EQUITY BANK LIMITED	NAIVASHA	247247	68	020	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1195	EQUITY BANK LIMITED	CHUKA	247247	68	021	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1196	EQUITY BANK LIMITED	MURANGA	247247	68	022	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1197	EQUITY BANK LIMITED	MOLO	247247	68	023	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1198	EQUITY BANK LIMITED	HARAMBEE AVENUE BIMA HOUSE	247247	68	024	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1199	EQUITY BANK LIMITED	MOMBASA UTC BUILDING	247247	68	025	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1200	EQUITY BANK LIMITED	KIMATHI STREET	247247	68	026	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1201	EQUITY BANK LIMITED	NANYUKI	247247	68	027	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1202	EQUITY BANK LIMITED	KERICHO	247247	68	028	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1203	EQUITY BANK LIMITED	KISUMU	247247	68	029	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1204	EQUITY BANK LIMITED	ELDORET	247247	68	030	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1205	EQUITY BANK LIMITED	NAKURU KENYATTA AVENUE	247247	68	031	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1206	EQUITY BANK LIMITED	KARIOBANGI	247247	68	032	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1207	EQUITY BANK LIMITED	KITALE	247247	68	033	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1208	EQUITY BANK LIMITED	Thika Kenyatta Avenue	247247	68	034	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1209	EQUITY BANK LIMITED	KNUT HOUSE	247247	68	035	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1210	EQUITY BANK LIMITED	NAROK	247247	68	036	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1211	EQUITY BANK LIMITED	NKUBU	247247	68	037	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1212	EQUITY BANK LIMITED	MWEA	247247	68	038	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1213	EQUITY BANK LIMITED	MATUU	247247	68	039	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1214	EQUITY BANK LIMITED	MAUA	247247	68	040	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1215	EQUITY BANK LIMITED	ISIOLO	247247	68	041	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1216	EQUITY BANK LIMITED	KAGIO	247247	68	042	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1217	EQUITY BANK LIMITED	GIKOMBA	247247	68	043	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1218	EQUITY BANK LIMITED	UKUNDA BRANCH	247247	68	044	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1219	EQUITY BANK LIMITED	MALINDI BRANCH	247247	68	045	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1220	EQUITY BANK LIMITED	MOMBASA DIGO ROAD BRANCH	247247	68	046	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1221	EQUITY BANK LIMITED	MOI AVENUE	247247	68	047	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1222	EQUITY BANK LIMITED	BUNGOMA BRANCH	247247	68	048	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1223	EQUITY BANK LIMITED	KAPSABET BRANCH	247247	68	049	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1224	EQUITY BANK LIMITED	KAKAMEGA BRANCH	247247	68	050	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1225	EQUITY BANK LIMITED	KISII BRANCH	247247	68	051	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1226	EQUITY BANK LIMITED	NYAMIRA BRANCH	247247	68	052	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1227	EQUITY BANK LIMITED	LITEIN	247247	68	053	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1228	EQUITY BANK LIMITED	Equity Centre Diaspora	247247	68	054	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1229	EQUITY BANK LIMITED	WESTLANDS	247247	68	055	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1230	EQUITY BANK LIMITED	Industrial Area Kenpipe Plaza	247247	68	056	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1231	EQUITY BANK LIMITED	KIKUYU BRANCH	247247	68	057	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1232	EQUITY BANK LIMITED	GARISSA BRANCH	247247	68	058	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1233	EQUITY BANK LIMITED	MWINGI BRANCH	247247	68	059	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1234	EQUITY BANK LIMITED	MACHAKOS BRANCH	247247	68	060	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1235	EQUITY BANK LIMITED	ONGATA RONGAI BRANCH	247247	68	061	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1236	EQUITY BANK LIMITED	OL-KALAO BRANCH	247247	68	062	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1237	EQUITY BANK LIMITED	KAWANGWARE BRANCH	247247	68	063	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1238	EQUITY BANK LIMITED	KIAMBU BRANCH	247247	68	064	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1239	EQUITY BANK LIMITED	KAYOLE BRANCH	247247	68	065	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1240	EQUITY BANK LIMITED	GATUNDU BRANCH	247247	68	066	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1241	EQUITY BANK LIMITED	WOTE BRANCH	247247	68	067	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1242	EQUITY BANK LIMITED	MUMIAS BRANCH	247247	68	068	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1243	EQUITY BANK LIMITED	LIMURU BRANCH	247247	68	069	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1244	EQUITY BANK LIMITED	KITENGELA BRANCH	247247	68	070	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1245	EQUITY BANK LIMITED	GITHURAI	247247	68	071	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1246	EQUITY BANK LIMITED	KITUI BRANCH	247247	68	072	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1247	EQUITY BANK LIMITED	NGONG BRANCH	247247	68	073	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1248	EQUITY BANK LIMITED	LOITOKTOK BRANCH	247247	68	074	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1249	EQUITY BANK LIMITED	BONDO BRANCH	247247	68	075	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1250	EQUITY BANK LIMITED	MBITA	247247	68	076	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1251	EQUITY BANK LIMITED	GILGIL BRANCH	247247	68	077	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1252	EQUITY BANK LIMITED	BUSIA	247247	68	078	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1253	EQUITY BANK LIMITED	VOI	247247	68	079	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1254	EQUITY BANK LIMITED	ENTERPRISE ROAD	247247	68	080	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1255	EQUITY BANK LIMITED	EQUITY CENTRE	247247	68	081	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1256	EQUITY BANK LIMITED	DONHOLM	247247	68	082	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1257	EQUITY BANK LIMITED	MUKURWE-INI	247247	68	083	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1258	EQUITY BANK LIMITED	EASTLEIGH	247247	68	084	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1259	EQUITY BANK LIMITED	NAMANGA	247247	68	085	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1260	EQUITY BANK LIMITED	KAJIADO	247247	68	086	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1261	EQUITY BANK LIMITED	RUIRU	247247	68	087	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1262	EQUITY BANK LIMITED	OTC	247247	68	088	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1263	EQUITY BANK LIMITED	KENOL	247247	68	089	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1264	EQUITY BANK LIMITED	TALA	247247	68	090	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1265	EQUITY BANK LIMITED	NGARA	247247	68	091	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1266	EQUITY BANK LIMITED	NANDI HILLS	247247	68	092	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1267	EQUITY BANK LIMITED	GITHUNGURI	247247	68	093	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1268	EQUITY BANK LIMITED	TEA ROOM	247247	68	094	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1269	EQUITY BANK LIMITED	BURUBURU	247247	68	095	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1270	EQUITY BANK LIMITED	MBALE	247247	68	096	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1271	EQUITY BANK LIMITED	SIAYA	247247	68	097	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1272	EQUITY BANK LIMITED	HOMA BAY	247247	68	098	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1273	EQUITY BANK LIMITED	LODWAR	247247	68	099	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1274	EQUITY BANK LIMITED	MANDERA	247247	68	100	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1275	EQUITY BANK LIMITED	MARSABIT	247247	68	101	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1276	EQUITY BANK LIMITED	MOYALE	247247	68	102	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1277	EQUITY BANK LIMITED	WAJIR	247247	68	103	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1278	EQUITY BANK LIMITED	MERU MAKUTANO	247247	68	104	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1279	EQUITY BANK LIMITED	Malaba Town	247247	68	105	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1280	EQUITY BANK LIMITED	KILIFI	247247	68	106	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1281	EQUITY BANK LIMITED	KAPENGURIA	247247	68	107	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1282	EQUITY BANK LIMITED	Mombasa Road	247247	68	108	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1283	EQUITY BANK LIMITED	ELDORET MARKET	247247	68	109	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1284	EQUITY BANK LIMITED	MARALAL	247247	68	110	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1285	EQUITY BANK LIMITED	KIMENDE	247247	68	111	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1286	EQUITY BANK LIMITED	LUANDA	247247	68	112	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1287	EQUITY BANK LIMITED	KU SUB BRANCH	247247	68	113	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1288	EQUITY BANK LIMITED	KENGELENI BRANCH	247247	68	114	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1289	EQUITY BANK LIMITED	NYERI KIMATHI WAY BRANCH	247247	68	115	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1290	EQUITY BANK LIMITED	MIGORI	247247	68	116	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1291	EQUITY BANK LIMITED	KIBERA	247247	68	117	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1292	EQUITY BANK LIMITED	KASARANI	247247	68	118	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1293	EQUITY BANK LIMITED	MTWAPA	247247	68	119	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1294	EQUITY BANK LIMITED	CHANGAMWE	247247	68	120	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1295	EQUITY BANK LIMITED	HOLA	247247	68	121	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1296	EQUITY BANK LIMITED	BOMET	247247	68	122	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1297	EQUITY BANK LIMITED	KILGORIS	247247	68	123	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1298	EQUITY BANK LIMITED	KEROKA	247247	68	124	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1299	EQUITY BANK LIMITED	KAREN	247247	68	125	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1300	EQUITY BANK LIMITED	KISUMU ANGAWA AVENUE	247247	68	126	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1301	EQUITY BANK LIMITED	MPEKETONI	247247	68	127	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1302	EQUITY BANK LIMITED	NAIROBI WEST	247247	68	128	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1303	EQUITY BANK LIMITED	KENYATTA AVENUE	247247	68	129	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1304	EQUITY BANK LIMITED	CITYHALL	247247	68	130	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1305	EQUITY BANK LIMITED	ELDAMARAVINE	247247	68	131	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1306	EQUITY BANK LIMITED	EMBAKASI	247247	68	132	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1307	EQUITY BANK LIMITED	KPCU	247247	68	133	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1308	EQUITY BANK LIMITED	RIDGEWAYS	247247	68	134	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1309	EQUITY BANK LIMITED	RUNYENJES SUB BRANCH	247247	68	135	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1310	EQUITY BANK LIMITED	DAADAB	247247	68	136	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1311	EQUITY BANK LIMITED	KANGEMI	247247	68	137	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1312	EQUITY BANK LIMITED	NYALI CENTRE CORPORATE	247247	68	138	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1313	EQUITY BANK LIMITED	KABARNET	247247	68	139	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1314	EQUITY BANK LIMITED	WESTLANDS CORPORATE	247247	68	140	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1315	EQUITY BANK LIMITED	LAVINGTON CORPORATE	247247	68	141	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1316	EQUITY BANK LIMITED	TAITA TAVETA	247247	68	142	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1317	EQUITY BANK LIMITED	AWENDO	247247	68	143	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1318	EQUITY BANK LIMITED	RUAI	247247	68	144	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1319	EQUITY BANK LIMITED	KILIMANI	247247	68	145	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1320	EQUITY BANK LIMITED	NAKURU WESTSIDE MALL	247247	68	146	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1321	EQUITY BANK LIMITED	KILIMANI SUPREME	247247	68	147	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1322	EQUITY BANK LIMITED	JKIA CARGO CENTRE	247247	68	148	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1323	EQUITY BANK LIMITED	EPZ ATHI RIVER	247247	68	149	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1324	EQUITY BANK LIMITED	OYUGIS	247247	68	150	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1325	EQUITY BANK LIMITED	MAYFAIR SUPREME CENTRE	247247	68	151	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1326	EQUITY BANK LIMITED	JUJA	247247	68	152	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1327	EQUITY BANK LIMITED	ITEN	247247	68	153	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1328	EQUITY BANK LIMITED	EWASO NYIRO	247247	68	154	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1329	EQUITY BANK LIMITED	THIKA SUPREME CENTRE	247247	68	155	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1330	EQUITY BANK LIMITED	MOMBASA SUPREME CENTRE	247247	68	156	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1331	EQUITY BANK LIMITED	KAPSOWAR SUB BRANCH	247247	68	157	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1332	EQUITY BANK LIMITED	KWALE	247247	68	158	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1333	EQUITY BANK LIMITED	LAMU	247247	68	159	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1334	EQUITY BANK LIMITED	KENYATTA AVENUE SUPREME	247247	68	160	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1335	EQUITY BANK LIMITED	KPA SUB BRANCH MOMBASA	247247	68	161	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1336	EQUITY BANK LIMITED	GIGIRI SUPREME CENTRE	247247	68	162	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1337	EQUITY BANK LIMITED	KAREN SUPREME CENTRE	247247	68	163	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1338	EQUITY BANK LIMITED	ELDORET SUPREME CENTRE	247247	68	164	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1339	EQUITY BANK LIMITED	KAKUMA SUB-BRANCH	247247	68	165	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1340	EQUITY BANK LIMITED	ARCHERS POST SUB-BRANCH	247247	68	166	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1341	EQUITY BANK LIMITED	MUTOMO	247247	68	167	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1342	EQUITY BANK LIMITED	SOLOLO	247247	68	168	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1343	EQUITY BANK LIMITED	Dagoretti Corner	247247	68	169	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1344	EQUITY BANK LIMITED	KISUMU SUPREME CENTRE	247247	68	170	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1345	EQUITY BANK LIMITED	THIKA MAKONGENI	247247	68	171	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1346	EQUITY BANK LIMITED	Garden City	247247	68	175	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1347	EQUITY BANK LIMITED	EQUITY HAPO HAPO	247247	68	777	EQBLKENA	40468000	PI/SAF	B0038	ACTIVE	0
1583931337	\N	1583931337	\N	1348	FAMILY BANK LIMITED	HEAD OFFICE	222111	70	000	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1349	FAMILY BANK LIMITED	KIAMBU	222111	70	001	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1350	FAMILY BANK LIMITED	GITHUNGURI	222111	70	002	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1351	FAMILY BANK LIMITED	SONALUX	222111	70	003	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1352	FAMILY BANK LIMITED	GATUNDU	222111	70	004	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1353	FAMILY BANK LIMITED	THIKA	222111	70	005	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1354	FAMILY BANK LIMITED	MURANGA	222111	70	006	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1355	FAMILY BANK LIMITED	KANGARI	222111	70	007	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1356	FAMILY BANK LIMITED	KIRIA-INI	222111	70	008	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1357	FAMILY BANK LIMITED	KANGEMA	222111	70	009	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1358	FAMILY BANK LIMITED	OTHAYA	222111	70	011	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1359	FAMILY BANK LIMITED	KENYATTA AVENUE	222111	70	012	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1360	FAMILY BANK LIMITED	Cargen House	222111	70	014	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1361	FAMILY BANK LIMITED	LAPTRUST	222111	70	015	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1362	FAMILY BANK LIMITED	CITY HALL ANNEX	222111	70	016	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1363	FAMILY BANK LIMITED	KASARANI	222111	70	017	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1364	FAMILY BANK LIMITED	NAKURU FINANCE HSE	222111	70	018	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1365	FAMILY BANK LIMITED	NAKURU MARKET BRANCH	222111	70	019	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1366	FAMILY BANK LIMITED	DAGORETTI	222111	70	021	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1367	FAMILY BANK LIMITED	KERICHO	222111	70	022	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1368	FAMILY BANK LIMITED	NYAHURURU	222111	70	023	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1369	FAMILY BANK LIMITED	RUIRU	222111	70	024	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1370	FAMILY BANK LIMITED	Kisumu Reliance	222111	70	025	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1371	FAMILY BANK LIMITED	NYAMIRA	222111	70	026	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1372	FAMILY BANK LIMITED	KISII	222111	70	027	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1373	FAMILY BANK LIMITED	KISUMU AL-IMRAN BRANCH	222111	70	028	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1374	FAMILY BANK LIMITED	NAROK	222111	70	029	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1375	FAMILY BANK LIMITED	INDUSTRIAL AREA	222111	70	031	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1376	FAMILY BANK LIMITED	THIKA MAKONGENI	222111	70	032	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1377	FAMILY BANK LIMITED	DONHOLM	222111	70	033	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1378	FAMILY BANK LIMITED	Utawala	222111	70	034	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1379	FAMILY BANK LIMITED	Fourways Retail Branch	222111	70	035	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1380	FAMILY BANK LIMITED	OLKALOU	222111	70	037	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1381	FAMILY BANK LIMITED	KTDA PLAZA	222111	70	038	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1382	FAMILY BANK LIMITED	GATEWAY MALL	222111	70	039	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1383	FAMILY BANK LIMITED	KARIOBANGI	222111	70	041	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1384	FAMILY BANK LIMITED	Gikomba Area 42	222111	70	042	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1385	FAMILY BANK LIMITED	Sokoni	222111	70	043	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1386	FAMILY BANK LIMITED	GITHURAI	222111	70	045	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1387	FAMILY BANK LIMITED	YAYA	222111	70	046	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1388	FAMILY BANK LIMITED	LIMURU	222111	70	047	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1389	FAMILY BANK LIMITED	WESTLANDS	222111	70	048	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1390	FAMILY BANK LIMITED	KAGWE	222111	70	049	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1391	FAMILY BANK LIMITED	BANANA BRANCH	222111	70	051	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1392	FAMILY BANK LIMITED	RUAKA	222111	70	052	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1393	FAMILY BANK LIMITED	NAIVASHA	222111	70	053	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1394	FAMILY BANK LIMITED	CHUKA	222111	70	054	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1395	FAMILY BANK LIMITED	NYERI	222111	70	055	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1396	FAMILY BANK LIMITED	KARATINA BRANCH	222111	70	056	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1397	FAMILY BANK LIMITED	KERUGOYA	222111	70	057	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1398	FAMILY BANK LIMITED	TOM MBOYA	222111	70	058	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1399	FAMILY BANK LIMITED	RIVER ROAD BRANCH	222111	70	059	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1400	FAMILY BANK LIMITED	KAYOLE	222111	70	061	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1401	FAMILY BANK LIMITED	NKUBU BRANCH	222111	70	062	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1402	FAMILY BANK LIMITED	MERU	222111	70	063	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1403	FAMILY BANK LIMITED	NANYUKI	222111	70	064	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1404	FAMILY BANK LIMITED	KTDA PLAZA CORPORATE	222111	70	065	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1405	FAMILY BANK LIMITED	ONGATA RONGAI	222111	70	066	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1406	FAMILY BANK LIMITED	KAJIADO	222111	70	067	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1407	FAMILY BANK LIMITED	Fourways Corporate Branch	222111	70	068	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1408	FAMILY BANK LIMITED	Ngara	222111	70	069	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1409	FAMILY BANK LIMITED	KITENGELA	222111	70	071	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1410	FAMILY BANK LIMITED	KITUI	222111	70	072	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1411	FAMILY BANK LIMITED	MACHAKOS	222111	70	073	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1412	FAMILY BANK LIMITED	MIGORI	222111	70	074	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1413	FAMILY BANK LIMITED	EMBU	222111	70	075	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1414	FAMILY BANK LIMITED	MWEA	222111	70	076	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1415	FAMILY BANK LIMITED	BUNGOMA	222111	70	077	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1416	FAMILY BANK LIMITED	KAKAMEGA	222111	70	078	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1417	FAMILY BANK LIMITED	BUSIA	222111	70	079	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1418	FAMILY BANK LIMITED	MUMIAS	222111	70	081	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1419	FAMILY BANK LIMITED	ELDORET WEST	222111	70	082	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1420	FAMILY BANK LIMITED	MOLO	222111	70	083	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1421	FAMILY BANK LIMITED	BOMET	222111	70	084	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1422	FAMILY BANK LIMITED	ELDORET	222111	70	085	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1423	FAMILY BANK LIMITED	LITEIN	222111	70	087	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1424	FAMILY BANK LIMITED	BAMBURI	222111	70	089	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1425	FAMILY BANK LIMITED	UKUNDA	222111	70	091	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1426	FAMILY BANK LIMITED	DIGO	222111	70	092	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1427	FAMILY BANK LIMITED	KITALE	222111	70	093	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1428	FAMILY BANK LIMITED	MTWAPA	222111	70	094	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1429	FAMILY BANK LIMITED	Mombasa Nkrumah Road	222111	70	095	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1430	FAMILY BANK LIMITED	Mombasa Jomo Kenyatta Avenue	222111	70	096	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1431	FAMILY BANK LIMITED	KAPSABET	222111	70	097	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1432	FAMILY BANK LIMITED	MALINDI	222111	70	098	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1433	FAMILY BANK LIMITED	KIKUYU	222111	70	102	FABLKENA	40470000	PI/SAF	B0039	ACTIVE	0
1583931337	\N	1583931337	\N	1434	GULF AFRICAN BANK	HEAD OFFICE	985050	72	000	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1435	GULF AFRICAN BANK	Central Clearing Centre	985050	72	001	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1436	GULF AFRICAN BANK	UPPERHILL	985050	72	002	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1437	GULF AFRICAN BANK	EASTLEIGH	985050	72	003	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1438	GULF AFRICAN BANK	KENYATTA AVENUE	985050	72	004	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1439	GULF AFRICAN BANK	MOMBASA BRANCH	985050	72	005	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1440	GULF AFRICAN BANK	GARISSA	985050	72	006	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1441	GULF AFRICAN BANK	LAMU	985050	72	007	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1442	GULF AFRICAN BANK	MALINDI	985050	72	008	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1443	GULF AFRICAN BANK	MUTHAIGA BRANCH	985050	72	009	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1444	GULF AFRICAN BANK	BONDENI MAIN	985050	72	010	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1445	GULF AFRICAN BANK	EASTLEIGH 7TH STREET	985050	72	011	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1446	GULF AFRICAN BANK	Eastleigh Athumani Kipanga Street	985050	72	012	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1447	GULF AFRICAN BANK	Westlands	985050	72	013	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1448	GULF AFRICAN BANK	INDUSTRIAL AREA	985050	72	014	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1449	GULF AFRICAN BANK	Jomo Kenyatta Avenue	985050	72	015	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1450	GULF AFRICAN BANK	BOMBULULU	985050	72	016	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1451	GULF AFRICAN BANK	MOMBASA ROAD	985050	72	017	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1452	GULF AFRICAN BANK	ANNISAA BONDENI	985050	72	018	GAFRKENA	40472000	PI/SAF	B0040	ACTIVE	0
1583931337	\N	1583931337	\N	1453	FIRST COMMUNITY BANK	WABERA STREET	919700	74	001	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1454	FIRST COMMUNITY BANK	AMAL PLAZA	919700	74	002	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1455	FIRST COMMUNITY BANK	Mombasa 1	919700	74	003	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1456	FIRST COMMUNITY BANK	GARISSA	919700	74	004	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1457	FIRST COMMUNITY BANK	Eastleigh 2 - General Waruing	919700	74	005	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1458	FIRST COMMUNITY BANK	MALINDI	919700	74	006	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1459	FIRST COMMUNITY BANK	KISUMU	919700	74	007	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1460	FIRST COMMUNITY BANK	KIMATHI STREET	919700	74	008	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1461	FIRST COMMUNITY BANK	WESTLANDS	919700	74	009	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1462	FIRST COMMUNITY BANK	SOUTH C BRANCH	919700	74	010	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1463	FIRST COMMUNITY BANK	INDUSTRIAL AREA	919700	74	011	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1464	FIRST COMMUNITY BANK	MASALANI	919700	74	012	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1465	FIRST COMMUNITY BANK	Habasweni	919700	74	013	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1466	FIRST COMMUNITY BANK	WAJIR	919700	74	014	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1467	FIRST COMMUNITY BANK	MOYALE	919700	74	015	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1468	FIRST COMMUNITY BANK	NAKURU	919700	74	016	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1469	FIRST COMMUNITY BANK	IMAARA	919700	74	017	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1470	FIRST COMMUNITY BANK	LUNGA LUNGA	919700	74	018	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1471	FIRST COMMUNITY BANK	Head Office/clearing Center	919700	74	999	IFCBKENA	40474000	PI/SAF	B0041	ACTIVE	0
1583931337	\N	1583931337	\N	1472	UBA KENYA BANK LTD	WESTLANDS	559900	76	001	UNAFKENA	\N	PI/SAF	B0042	ACTIVE	0
1583931337	\N	1583931337	\N	1473	UBA KENYA BANK LTD	ENTERPRISE ROAD BRANCH	559900	76	002	UNAFKENA	\N	PI/SAF	B0042	ACTIVE	0
1583931337	\N	1583931337	\N	1474	UBA KENYA BANK LTD	UPPER HILL BRANCH	559900	76	003	UNAFKENA	\N	PI/SAF	B0042	ACTIVE	0
1583931337	\N	1583931337	\N	1475	UBA KENYA BANK LTD	Head Office	559900	76	099	UNAFKENA	\N	PI/SAF	B0042	ACTIVE	0
1583931337	\N	1583931337	\N	1476	KWFT BANK	Kakamega Branch	101200	78	001	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1477	KWFT BANK	Eldoret Branch	101200	78	002	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1478	KWFT BANK	NYERI BRANCH	101200	78	003	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1479	KWFT BANK	MOMBASA BRANCH	101200	78	004	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1480	KWFT BANK	RIVER RD BRANCH	101200	78	005	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1481	KWFT BANK	MALINDI BRANCH	101200	78	006	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1482	KWFT BANK	KERICHO BRANCH	101200	78	007	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1483	KWFT BANK	MACHAKOS BRANCH	101200	78	008	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1484	KWFT BANK	EMBU BRANCH	101200	78	009	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1485	KWFT BANK	KISII BRANCH	101200	78	010	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1486	KWFT BANK	NANYUKI BRANCH	101200	78	011	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1487	KWFT BANK	MIGORI BRANCH	101200	78	012	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1488	KWFT BANK	THIKA BRANCH	101200	78	013	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1489	KWFT BANK	KITALE BRANCH	101200	78	014	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1490	KWFT BANK	NAKURU BRANCH	101200	78	015	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1491	KWFT BANK	EMALI BRANCH	101200	78	016	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1492	KWFT BANK	VOI BRANCH	101200	78	017	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1493	KWFT BANK	KISUMU BRANCH	101200	78	018	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1494	KWFT BANK	MERU BRANCH	101200	78	019	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1495	KWFT BANK	DIANI BRANCH	101200	78	020	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1496	KWFT BANK	UPPERHILL BRANCH	101200	78	021	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1497	KWFT BANK	NAIVASHA BRANCH	101200	78	022	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1498	KWFT BANK	BUSIA BRANCH	101200	78	024	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1499	KWFT BANK	KARIOBANGI BRANCH	101200	78	027	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1500	KWFT BANK	BUNGOMA BRANCH	101200	78	028	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1501	KWFT BANK	BOMET BRANCH	101200	78	029	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1502	KWFT BANK	KAWANGWARE BRANCH	101200	78	031	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1503	KWFT BANK	GIKOMBA BRANCH	101200	78	032	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1504	KWFT BANK	KIAMBU BRANCH	101200	78	033	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1505	KWFT BANK	RONGAI BRANCH	101200	78	034	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1506	KWFT BANK	MARSABIT BRANCH	101200	78	041	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1507	KWFT BANK	LODWAR BRANCH	101200	78	043	KWMIKENX	40478000	PI/SAF	B0043	ACTIVE	0
1583931337	\N	1583931337	\N	1508	IMPERIAL BANK OF KENYA	\N	800100	39	001	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1509	IMPERIAL BANK OF KENYA	\N	800100	39	002	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1510	IMPERIAL BANK OF KENYA	\N	800100	39	003	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1511	IMPERIAL BANK OF KENYA	\N	800100	39	004	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1512	IMPERIAL BANK OF KENYA	\N	800100	39	005	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1513	IMPERIAL BANK OF KENYA	\N	800100	39	006	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1514	IMPERIAL BANK OF KENYA	\N	800100	39	007	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1515	IMPERIAL BANK OF KENYA	\N	800100	39	008	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1516	IMPERIAL BANK OF KENYA	\N	800100	39	009	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1517	IMPERIAL BANK OF KENYA	\N	800100	39	010	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1518	IMPERIAL BANK OF KENYA	\N	800100	39	011	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1519	IMPERIAL BANK OF KENYA	\N	800100	39	012	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1520	IMPERIAL BANK OF KENYA	\N	800100	39	013	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1521	IMPERIAL BANK OF KENYA	\N	800100	39	014	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1522	IMPERIAL BANK OF KENYA	\N	800100	39	015	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1523	IMPERIAL BANK OF KENYA	\N	800100	39	016	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1524	IMPERIAL BANK OF KENYA	\N	800100	39	017	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1525	IMPERIAL BANK OF KENYA	\N	800100	39	018	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1526	IMPERIAL BANK OF KENYA	\N	800100	39	019	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1527	IMPERIAL BANK OF KENYA	\N	800100	39	020	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1528	IMPERIAL BANK OF KENYA	\N	800100	39	021	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1529	IMPERIAL BANK OF KENYA	\N	800100	39	022	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1530	IMPERIAL BANK OF KENYA	\N	800100	39	023	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1531	IMPERIAL BANK OF KENYA	\N	800100	39	024	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1532	IMPERIAL BANK OF KENYA	\N	800100	39	025	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1533	IMPERIAL BANK OF KENYA	\N	800100	39	026	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
1583931337	\N	1583931337	\N	1534	IMPERIAL BANK OF KENYA	\N	800100	39	027	IMPLKENA	\N	PI/SAF	B0044	ACTIVE	0
\.


--
-- Data for Name: tbl_sys_currencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_currencies (date_time_added, added_by, date_time_modified, modified_by, currency_id, currency_name, currency_code, currency_status, record_version) FROM stdin;
1583931528	\N	1583931528	\N	1	Afghani	AFN	ACTIVE	0
1583931528	\N	1583931528	\N	2	Lek	ALL	ACTIVE	0
1583931528	\N	1583931528	\N	3	Armenian Dram	AMD	ACTIVE	0
1583931528	\N	1583931528	\N	4	Netherlands Antillian Guilder	ANG	ACTIVE	0
1583931528	\N	1583931528	\N	5	Kwanza	AOA	ACTIVE	0
1583931528	\N	1583931528	\N	6	Argentine Peso	ARS	ACTIVE	0
1583931528	\N	1583931528	\N	7	Australian Dollar	AUD	ACTIVE	0
1583931528	\N	1583931528	\N	8	Aruban Guilder	AWG	ACTIVE	0
1583931528	\N	1583931528	\N	9	Azerbaijanian Manat	AZN	ACTIVE	0
1583931528	\N	1583931528	\N	10	Convertible Marks	BAM	ACTIVE	0
1583931528	\N	1583931528	\N	11	Barbados Dollar	BBD	ACTIVE	0
1583931528	\N	1583931528	\N	12	Bangladeshi Taka	BDT	ACTIVE	0
1583931528	\N	1583931528	\N	13	Bulgarian Lev	BGN	ACTIVE	0
1583931528	\N	1583931528	\N	14	Bahraini Dinar	BHD	ACTIVE	0
1583931528	\N	1583931528	\N	15	Burundian Franc	BIF	ACTIVE	0
1583931528	\N	1583931528	\N	16	Bermudian Dollar	BMD	ACTIVE	0
1583931528	\N	1583931528	\N	17	Brunei Dollar	BND	ACTIVE	0
1583931528	\N	1583931528	\N	18	Boliviano	BOB	ACTIVE	0
1583931528	\N	1583931528	\N	19	Bolivian Mvdol	BOV	ACTIVE	0
1583931528	\N	1583931528	\N	20	Brazilian Real	BRL	ACTIVE	0
1583931528	\N	1583931528	\N	21	Bahamian Dollar	BSD	ACTIVE	0
1583931528	\N	1583931528	\N	22	Ngultrum	BTN	ACTIVE	0
1583931528	\N	1583931528	\N	23	Pula	BWP	ACTIVE	0
1583931528	\N	1583931528	\N	24	Belarussian Ruble	BYR	ACTIVE	0
1583931528	\N	1583931528	\N	25	Belize Dollar	BZD	ACTIVE	0
1583931528	\N	1583931528	\N	26	Canadian Dollar	CAD	ACTIVE	0
1583931528	\N	1583931528	\N	27	Franc Congolais	CDF	ACTIVE	0
1583931528	\N	1583931528	\N	28	WIR Euro	CHE	ACTIVE	0
1583931528	\N	1583931528	\N	29	Swiss Franc	CHF	ACTIVE	0
1583931528	\N	1583931528	\N	30	WIR Franc	CHW	ACTIVE	0
1583931528	\N	1583931528	\N	31	Unidades de formento	CLF	ACTIVE	0
1583931528	\N	1583931528	\N	32	Chilean Peso	CLP	ACTIVE	0
1583931528	\N	1583931528	\N	33	Yuan Renminbi	CNY	ACTIVE	0
1583931528	\N	1583931528	\N	34	Colombian Peso	COP	ACTIVE	0
1583931528	\N	1583931528	\N	35	Unidad de Valor Real	COU	ACTIVE	0
1583931528	\N	1583931528	\N	36	Costa Rican Colon	CRC	ACTIVE	0
1583931528	\N	1583931528	\N	37	Cuban Peso	CUP	ACTIVE	0
1583931528	\N	1583931528	\N	38	Cape Verde Escudo	CVE	ACTIVE	0
1583931528	\N	1583931528	\N	39	Cyprus Pound	CYP	ACTIVE	0
1583931528	\N	1583931528	\N	40	Czech Koruna	CZK	ACTIVE	0
1583931528	\N	1583931528	\N	41	Djibouti Franc	DJF	ACTIVE	0
1583931528	\N	1583931528	\N	42	Danish Krone	DKK	ACTIVE	0
1583931528	\N	1583931528	\N	43	Dominican Peso	DOP	ACTIVE	0
1583931528	\N	1583931528	\N	44	Algerian Dinar	DZD	ACTIVE	0
1583931528	\N	1583931528	\N	45	Kroon	EEK	ACTIVE	0
1583931528	\N	1583931528	\N	46	Egyptian Pound	EGP	ACTIVE	0
1583931528	\N	1583931528	\N	47	Nakfa	ERN	ACTIVE	0
1583931528	\N	1583931528	\N	48	Ethiopian Birr	ETB	ACTIVE	0
1583931528	\N	1583931528	\N	49	Euro	EUR	ACTIVE	0
1583931528	\N	1583931528	\N	50	Fiji Dollar	FJD	ACTIVE	0
1583931528	\N	1583931528	\N	51	Falkland Islands Pound	FKP	ACTIVE	0
1583931528	\N	1583931528	\N	52	Pound Sterling	GBP	ACTIVE	0
1583931528	\N	1583931528	\N	53	Lari	GEL	ACTIVE	0
1583931528	\N	1583931528	\N	54	Cedi	GHS	ACTIVE	0
1583931528	\N	1583931528	\N	55	Gibraltar pound	GIP	ACTIVE	0
1583931528	\N	1583931528	\N	56	Dalasi	GMD	ACTIVE	0
1583931528	\N	1583931528	\N	57	Guinea Franc	GNF	ACTIVE	0
1583931528	\N	1583931528	\N	58	Quetzal	GTQ	ACTIVE	0
1583931528	\N	1583931528	\N	59	Guyana Dollar	GYD	ACTIVE	0
1583931528	\N	1583931528	\N	60	Hong Kong Dollar	HKD	ACTIVE	0
1583931528	\N	1583931528	\N	61	Lempira	HNL	ACTIVE	0
1583931528	\N	1583931528	\N	62	Croatian Kuna	HRK	ACTIVE	0
1583931528	\N	1583931528	\N	63	Haiti Gourde	HTG	ACTIVE	0
1583931528	\N	1583931528	\N	64	Forint	HUF	ACTIVE	0
1583931528	\N	1583931528	\N	65	Rupiah	IDR	ACTIVE	0
1583931528	\N	1583931528	\N	66	New Israeli Shekel	ILS	ACTIVE	0
1583931528	\N	1583931528	\N	67	Indian Rupee	INR	ACTIVE	0
1583931528	\N	1583931528	\N	68	Iraqi Dinar	IQD	ACTIVE	0
1583931528	\N	1583931528	\N	69	Iranian Rial	IRR	ACTIVE	0
1583931528	\N	1583931528	\N	70	Iceland Krona	ISK	ACTIVE	0
1583931528	\N	1583931528	\N	71	Jamaican Dollar	JMD	ACTIVE	0
1583931528	\N	1583931528	\N	72	Jordanian Dinar	JOD	ACTIVE	0
1583931528	\N	1583931528	\N	73	Japanese yen	JPY	ACTIVE	0
1583931528	\N	1583931528	\N	74	Kenyan Shilling	KES	ACTIVE	0
1583931528	\N	1583931528	\N	75	Som	KGS	ACTIVE	0
1583931528	\N	1583931528	\N	76	Riel	KHR	ACTIVE	0
1583931528	\N	1583931528	\N	77	Comoro Franc	KMF	ACTIVE	0
1583931528	\N	1583931528	\N	78	North Korean Won	KPW	ACTIVE	0
1583931528	\N	1583931528	\N	79	South Korean Won	KRW	ACTIVE	0
1583931528	\N	1583931528	\N	80	Kuwaiti Dinar	KWD	ACTIVE	0
1583931528	\N	1583931528	\N	81	Cayman Islands Dollar	KYD	ACTIVE	0
1583931528	\N	1583931528	\N	82	Tenge	KZT	ACTIVE	0
1583931528	\N	1583931528	\N	83	Kip	LAK	ACTIVE	0
1583931528	\N	1583931528	\N	84	Lebanese Pound	LBP	ACTIVE	0
1583931528	\N	1583931528	\N	85	Sri Lanka Rupee	LKR	ACTIVE	0
1583931528	\N	1583931528	\N	86	Liberian Dollar	LRD	ACTIVE	0
1583931528	\N	1583931528	\N	87	Loti	LSL	ACTIVE	0
1583931528	\N	1583931528	\N	88	Lithuanian Litas	LTL	ACTIVE	0
1583931528	\N	1583931528	\N	89	Latvian Lats	LVL	ACTIVE	0
1583931528	\N	1583931528	\N	90	Libyan Dinar	LYD	ACTIVE	0
1583931528	\N	1583931528	\N	91	Moroccan Dirham	MAD	ACTIVE	0
1583931528	\N	1583931528	\N	92	Moldovan Leu	MDL	ACTIVE	0
1583931528	\N	1583931528	\N	93	Malagasy Ariary	MGA	ACTIVE	0
1583931528	\N	1583931528	\N	94	Denar	MKD	ACTIVE	0
1583931528	\N	1583931528	\N	95	Kyat	MMK	ACTIVE	0
1583931528	\N	1583931528	\N	96	Tugrik	MNT	ACTIVE	0
1583931528	\N	1583931528	\N	97	Pataca	MOP	ACTIVE	0
1583931528	\N	1583931528	\N	98	Ouguiya	MRO	ACTIVE	0
1583931528	\N	1583931528	\N	99	Maltese Lira	MTL	ACTIVE	0
1583931528	\N	1583931528	\N	100	Mauritius Rupee	MUR	ACTIVE	0
1583931528	\N	1583931528	\N	101	Rufiyaa	MVR	ACTIVE	0
1583931528	\N	1583931528	\N	102	Kwacha	MWK	ACTIVE	0
1583931528	\N	1583931528	\N	103	Mexican Peso	MXN	ACTIVE	0
1583931528	\N	1583931528	\N	104	Mexican Unidad de Inversion (UDI)	MXV	ACTIVE	0
1583931528	\N	1583931528	\N	105	Malaysian Ringgit	MYR	ACTIVE	0
1583931528	\N	1583931528	\N	106	Metical	MZN	ACTIVE	0
1583931528	\N	1583931528	\N	107	Namibian Dollar	NAD	ACTIVE	0
1583931528	\N	1583931528	\N	108	Naira	NGN	ACTIVE	0
1583931528	\N	1583931528	\N	109	Cordoba Oro	NIO	ACTIVE	0
1583931528	\N	1583931528	\N	110	Norwegian Krone	NOK	ACTIVE	0
1583931528	\N	1583931528	\N	111	Nepalese Rupee	NPR	ACTIVE	0
1583931528	\N	1583931528	\N	112	New Zealand Dollar	NZD	ACTIVE	0
1583931528	\N	1583931528	\N	113	Rial Omani	OMR	ACTIVE	0
1583931528	\N	1583931528	\N	114	Balboa	PAB	ACTIVE	0
1583931528	\N	1583931528	\N	115	Nuevo Sol	PEN	ACTIVE	0
1583931528	\N	1583931528	\N	116	Kina	PGK	ACTIVE	0
1583931528	\N	1583931528	\N	117	Philippine Peso	PHP	ACTIVE	0
1583931528	\N	1583931528	\N	118	Pakistan Rupee	PKR	ACTIVE	0
1583931528	\N	1583931528	\N	119	Zloty	PLN	ACTIVE	0
1583931528	\N	1583931528	\N	120	Guarani	PYG	ACTIVE	0
1583931528	\N	1583931528	\N	121	Qatari Rial	QAR	ACTIVE	0
1583931528	\N	1583931528	\N	122	Romanian New Leu	RON	ACTIVE	0
1583931528	\N	1583931528	\N	123	Serbian Dinar	RSD	ACTIVE	0
1583931528	\N	1583931528	\N	124	Russian Ruble	RUB	ACTIVE	0
1583931528	\N	1583931528	\N	125	Rwanda Franc	RWF	ACTIVE	0
1583931528	\N	1583931528	\N	126	Saudi Riyal	SAR	ACTIVE	0
1583931528	\N	1583931528	\N	127	Solomon Islands Dollar	SBD	ACTIVE	0
1583931528	\N	1583931528	\N	128	Seychelles Rupee	SCR	ACTIVE	0
1583931528	\N	1583931528	\N	129	Sudanese Pound	SDG	ACTIVE	0
1583931528	\N	1583931528	\N	130	Swedish Krona	SEK	ACTIVE	0
1583931528	\N	1583931528	\N	131	Singapore Dollar	SGD	ACTIVE	0
1583931528	\N	1583931528	\N	132	Saint Helena Pound	SHP	ACTIVE	0
1583931528	\N	1583931528	\N	133	Slovak Koruna	SKK	ACTIVE	0
1583931528	\N	1583931528	\N	134	Leone	SLL	ACTIVE	0
1583931528	\N	1583931528	\N	135	Somali Shilling	SOS	ACTIVE	0
1583931528	\N	1583931528	\N	136	Surinam Dollar	SRD	ACTIVE	0
1583931528	\N	1583931528	\N	137	Dobra	STD	ACTIVE	0
1583931528	\N	1583931528	\N	138	Syrian Pound	SYP	ACTIVE	0
1583931528	\N	1583931528	\N	139	Lilangeni	SZL	ACTIVE	0
1583931528	\N	1583931528	\N	140	Baht	THB	ACTIVE	0
1583931528	\N	1583931528	\N	141	Somoni	TJS	ACTIVE	0
1583931528	\N	1583931528	\N	142	Manat	TMM	ACTIVE	0
1583931528	\N	1583931528	\N	143	Tunisian Dinar	TND	ACTIVE	0
1583931528	\N	1583931528	\N	144	Pa'anga	TOP	ACTIVE	0
1583931528	\N	1583931528	\N	145	New Turkish Lira	TRY	ACTIVE	0
1583931528	\N	1583931528	\N	146	Trinidad and Tobago Dollar	TTD	ACTIVE	0
1583931528	\N	1583931528	\N	147	New Taiwan Dollar	TWD	ACTIVE	0
1583931528	\N	1583931528	\N	148	Tanzanian Shilling	TZS	ACTIVE	0
1583931528	\N	1583931528	\N	149	Hryvnia	UAH	ACTIVE	0
1583931528	\N	1583931528	\N	150	Uganda Shilling	UGX	ACTIVE	0
1583931528	\N	1583931528	\N	151	US Dollar	USD	ACTIVE	0
1583931528	\N	1583931528	\N	152	CFA Franc BEAC	XAF	ACTIVE	0
1583931528	\N	1583931528	\N	153	Silver (one troy ounce)	XAG	ACTIVE	0
1583931528	\N	1583931528	\N	154	Gold (one troy ounce)	XAU	ACTIVE	0
1583931528	\N	1583931528	\N	155	East Carribean Dollar	XCD	ACTIVE	0
1583931528	\N	1583931528	\N	156	Palladium (one troy ounce)	XPT	ACTIVE	0
1583931528	\N	1583931528	\N	157	No Currency	XXX	ACTIVE	0
1586349158	\N	1586349158	\N	158	United Arab Emirates Dirham	AED	ACTIVE	0
\.


--
-- Data for Name: tbl_sys_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_documents (date_time_added, added_by, date_time_modified, modified_by, document_id, document_type, document_status) FROM stdin;
1583931692	\N	1583931692	\N	1	National ID	ACTIVE
1583931692	\N	1583931692	\N	2	Passport	ACTIVE
1583931692	\N	1583931692	\N	3	Drivers Licence	ACTIVE
1583931692	\N	1583931692	\N	4	Certificate of Registration	ACTIVE
1583931692	\N	1583931692	\N	5	Certificate of Incorporation	ACTIVE
1583931692	\N	1583931692	\N	6	Resident alien card	ACTIVE
1583931692	\N	1583931692	\N	7	Diplomatic Card	ACTIVE
1583931692	\N	1583931692	\N	8	Military Card	ACTIVE
1583931692	\N	1583931692	\N	9	Refugee/UNHCR certificate	ACTIVE
1583931692	\N	1583931692	\N	10	Pin Certificate	ACTIVE
1583931692	\N	1583931692	\N	11	Business Permit	ACTIVE
1583931692	\N	1583931692	\N	12	Purchase order	ACTIVE
1583931692	\N	1583931692	\N	13	Other	ACTIVE
\.


--
-- Data for Name: tbl_sys_iso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_iso (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, iso_id, prev_iso_id, company_id, need_sync, synced, iso_source, iso_type, request_type, iso_status, iso_version, req_mti, req_field1, req_field2, req_field3, req_field4, req_field5, req_field6, req_field7, req_field8, req_field9, req_field10, req_field11, req_field12, req_field13, req_field14, req_field15, req_field16, req_field17, req_field18, req_field19, req_field20, req_field21, req_field22, req_field23, req_field24, req_field25, req_field26, req_field27, req_field28, req_field29, req_field30, req_field31, req_field32, req_field33, req_field34, req_field35, req_field36, req_field37, req_field38, req_field39, req_field40, req_field41, req_field42, req_field43, req_field44, req_field45, req_field46, req_field47, req_field48, req_field49, req_field50, req_field51, req_field52, req_field53, req_field54, req_field55, req_field56, req_field57, req_field58, req_field59, req_field60, req_field61, req_field62, req_field63, req_field64, req_field65, req_field66, req_field67, req_field68, req_field69, req_field70, req_field71, req_field72, req_field73, req_field74, req_field75, req_field76, req_field77, req_field78, req_field79, req_field80, req_field81, req_field82, req_field83, req_field84, req_field85, req_field86, req_field87, req_field88, req_field89, req_field90, req_field91, req_field92, req_field93, req_field94, req_field95, req_field96, req_field97, req_field98, req_field99, req_field100, req_field101, req_field102, req_field103, req_field104, req_field105, req_field106, req_field107, req_field108, req_field109, req_field110, req_field111, req_field112, req_field113, req_field114, req_field115, req_field116, req_field117, req_field118, req_field119, req_field120, req_field121, req_field122, req_field123, req_field124, req_field125, req_field126, req_field127, req_field128, res_mti, res_field1, res_field2, res_field3, res_field4, res_field5, res_field6, res_field7, res_field8, res_field9, res_field10, res_field11, res_field12, res_field13, res_field14, res_field15, res_field16, res_field17, res_field18, res_field19, res_field20, res_field21, res_field22, res_field23, res_field24, res_field25, res_field26, res_field27, res_field28, res_field29, res_field30, res_field31, res_field32, res_field33, res_field34, res_field35, res_field36, res_field37, res_field38, res_field39, res_field40, res_field41, res_field42, res_field43, res_field44, res_field45, res_field46, res_field47, res_field48, res_field49, res_field50, res_field51, res_field52, res_field53, res_field54, res_field55, res_field56, res_field57, res_field58, res_field59, res_field60, res_field61, res_field62, res_field63, res_field64, res_field65, res_field66, res_field67, res_field68, res_field69, res_field70, res_field71, res_field72, res_field73, res_field74, res_field75, res_field76, res_field77, res_field78, res_field79, res_field80, res_field81, res_field82, res_field83, res_field84, res_field85, res_field86, res_field87, res_field88, res_field89, res_field90, res_field91, res_field92, res_field93, res_field94, res_field95, res_field96, res_field97, res_field98, res_field99, res_field100, res_field101, res_field102, res_field103, res_field104, res_field105, res_field106, res_field107, res_field108, res_field109, res_field110, res_field111, res_field112, res_field113, res_field114, res_field115, res_field116, res_field117, res_field118, res_field119, res_field120, res_field121, res_field122, res_field123, res_field124, res_field125, res_field126, res_field127, res_field128, request, response, extra_data, sync_message, need_sending, sent, received, aml_check, aml_check_sent, aml_check_retries, aml_listed, posted, created_at, deleted_at, maker_checker_approve_status, maker_checker_reject_status, approved_at, rejected_at) FROM stdin;
1587812686363	0	1589280256000	2	\N	\N	1816	\N	\N	t	f	API	ISO-8583	\N	\N	1	0200	\N	2547201	410000	200000      	20000       	\N	20200425  	\N	100     	\N	1587812686294  	020446	0425	0425	0425	\N	\N	0425	KEN	\N	KEN	\N	\N	\N	\N	\N	\N	0       	0       	0       	0       	SWLU0004	200425000012	acd4e36d3dd5	\N	\N	200425000012	\N	\N	\N	MPESA   	1677           	\N	\N	\N	\N	\N	\N	USD	KES	\N	88998899        	11223344          	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	KEN	\N	\N	\N	20200325  	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	254708374149	600193	\N	Lee KAMAU	JOHN DOE'S ADDRESS	NAIROBI	BEN WERU	RECIEVER ADDRESS	NAIROBI	Nairobi	N/A	N/A	EQBLKENA	KANGEMA	N/A	SAFARICOM	sender_id_type	Passport	P	P	M	LULU	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e36d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	\N	\N	\N	\N	0210	\N	2547201	410000	200000      	\N	\N	20200425  	\N	\N	\N	\N	020446	0425	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	SWLU0004	\N	\N	\N	\N	200425000012	\N	10	\N	\N	\N	\N	<p>maximum no. of retries</p>	\N	\N	\N	FAILED	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	254708374149	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	14050200FABE681FC8C0D8000880000006FFFFF0072547201410000200000      20000       20200425  100     1587812686294  0204460425042504250425KENKEN0       0       0       0       08SWLU00041220042500001212acd4e36d3dd5200425000012MPESA   1677           USDKES88998899        11223344          KEN20200325  1225470837414906600193009Lee KAMAU018JOHN DOE'S ADDRESS007NAIROBI008BEN WERU016RECIEVER ADDRESS007NAIROBI007Nairobi003N/A003N/A008EQBLKENA007KANGEMA003N/A009SAFARICOM014sender_id_type008Passport001P001PM004LULU898{entries=[{partner_id=SWLU0004, transaction_ref=acd4e36d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	01370210F21800010A0180000000000004000000072547201410000200000      20200425  020446042508SWLU0004200425000012090009AML-CHECKUSD12254708374149	01370210F21800010A0180000000000004000000072547201410000200000      20200425  020446042508SWLU0004200425000012090009AML-CHECKUSD12254708374149	\N	t	f	f	t	t	1	f	f	2020-04-25 14:04:46.336228+03	\N	1	0	1589280269	\N
1587812637512	0	1588840373000	2	\N	\N	1815	\N	\N	t	f	API	ISO-8583	\N	\N	1	0200	\N	2547201	410000	200000      	20000       	\N	20200425  	\N	100     	\N	1587812637427  	020357	0425	0425	0425	\N	\N	0425	KEN	\N	KEN	\N	\N	\N	\N	\N	\N	0       	0       	0       	0       	SWLU0004	200425000013	acd4e336d3dd5	\N	\N	200425000013	\N	\N	\N	MPESA   	1678           	\N	\N	\N	\N	\N	\N	USD	KES	\N	88998899        	11223344          	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	KEN	\N	\N	\N	20200325  	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	254708374149	600193	\N	Lee KAMAU	JOHN DOE'S ADDRESS	NAIROBI	BEN WERU	RECIEVER ADDRESS	NAIROBI	Nairobi	N/A	N/A	EQBLKENA	KANGEMA	N/A	SAFARICOM	sender_id_type	Passport	P	P	M	LULU	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e336d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	\N	\N	\N	\N	0210	\N	2547201	410000	200000      	\N	\N	20200425  	\N	\N	\N	\N	020357	0425	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	SWLU0004	\N	\N	\N	\N	200425000013	\N	10	\N	\N	\N	\N	AML-FAILED	\N	\N	\N	AML-FAILED	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	254708374149	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	14070200FABE681FC8C0D8000880000006FFFFF0072547201410000200000      20000       20200425  100     1587812637427  0203570425042504250425KENKEN0       0       0       0       08SWLU00041220042500001313acd4e336d3dd5200425000013MPESA   1678           USDKES88998899        11223344          KEN20200325  1225470837414906600193009Lee KAMAU018JOHN DOE'S ADDRESS007NAIROBI008BEN WERU016RECIEVER ADDRESS007NAIROBI007Nairobi003N/A003N/A008EQBLKENA007KANGEMA003N/A009SAFARICOM014sender_id_type008Passport001P001PM004LULU899{entries=[{partner_id=SWLU0004, transaction_ref=acd4e336d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	01370210F21800010A0180000000000004000000072547201410000200000      20200425  020357042508SWLU0004200425000013090009AML-CHECKUSD12254708374149	01370210F21800010A0180000000000004000000072547201410000200000      20200425  020357042508SWLU0004200425000013090009AML-CHECKUSD12254708374149	\N	t	f	f	t	t	1	f	f	2020-04-25 14:03:57.485853+03	\N	1	0	1588843076	\N
\.


--
-- Data for Name: tbl_sys_iso_eod; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_iso_eod (date_time_added, date_time_modified, eod_id, retry_at) FROM stdin;
1576571340	1576571340	1	1576571340
\.


--
-- Data for Name: tbl_sys_iso_eod_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_iso_eod_requests (date_time_added, date_time_modified, eod_request_id, field37, retries) FROM stdin;
\.


--
-- Data for Name: tbl_sys_iso_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_iso_types (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, iso_type_id, company_id, iso_type, description, entries) FROM stdin;
\.


--
-- Data for Name: tbl_sys_offline_iso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_offline_iso (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, iso_offline_id, iso_id, prev_iso_id, company_id, need_sync, synced, iso_source, iso_type, request_type, iso_status, iso_version, req_mti, req_field1, req_field2, req_field3, req_field4, req_field5, req_field6, req_field7, req_field8, req_field9, req_field10, req_field11, req_field12, req_field13, req_field14, req_field15, req_field16, req_field17, req_field18, req_field19, req_field20, req_field21, req_field22, req_field23, req_field24, req_field25, req_field26, req_field27, req_field28, req_field29, req_field30, req_field31, req_field32, req_field33, req_field34, req_field35, req_field36, req_field37, req_field38, req_field39, req_field40, req_field41, req_field42, req_field43, req_field44, req_field45, req_field46, req_field47, req_field48, req_field49, req_field50, req_field51, req_field52, req_field53, req_field54, req_field55, req_field56, req_field57, req_field58, req_field59, req_field60, req_field61, req_field62, req_field63, req_field64, req_field65, req_field66, req_field67, req_field68, req_field69, req_field70, req_field71, req_field72, req_field73, req_field74, req_field75, req_field76, req_field77, req_field78, req_field79, req_field80, req_field81, req_field82, req_field83, req_field84, req_field85, req_field86, req_field87, req_field88, req_field89, req_field90, req_field91, req_field92, req_field93, req_field94, req_field95, req_field96, req_field97, req_field98, req_field99, req_field100, req_field101, req_field102, req_field103, req_field104, req_field105, req_field106, req_field107, req_field108, req_field109, req_field110, req_field111, req_field112, req_field113, req_field114, req_field115, req_field116, req_field117, req_field118, req_field119, req_field120, req_field121, req_field122, req_field123, req_field124, req_field125, req_field126, req_field127, req_field128, res_mti, res_field1, res_field2, res_field3, res_field4, res_field5, res_field6, res_field7, res_field8, res_field9, res_field10, res_field11, res_field12, res_field13, res_field14, res_field15, res_field16, res_field17, res_field18, res_field19, res_field20, res_field21, res_field22, res_field23, res_field24, res_field25, res_field26, res_field27, res_field28, res_field29, res_field30, res_field31, res_field32, res_field33, res_field34, res_field35, res_field36, res_field37, res_field38, res_field39, res_field40, res_field41, res_field42, res_field43, res_field44, res_field45, res_field46, res_field47, res_field48, res_field49, res_field50, res_field51, res_field52, res_field53, res_field54, res_field55, res_field56, res_field57, res_field58, res_field59, res_field60, res_field61, res_field62, res_field63, res_field64, res_field65, res_field66, res_field67, res_field68, res_field69, res_field70, res_field71, res_field72, res_field73, res_field74, res_field75, res_field76, res_field77, res_field78, res_field79, res_field80, res_field81, res_field82, res_field83, res_field84, res_field85, res_field86, res_field87, res_field88, res_field89, res_field90, res_field91, res_field92, res_field93, res_field94, res_field95, res_field96, res_field97, res_field98, res_field99, res_field100, res_field101, res_field102, res_field103, res_field104, res_field105, res_field106, res_field107, res_field108, res_field109, res_field110, res_field111, res_field112, res_field113, res_field114, res_field115, res_field116, res_field117, res_field118, res_field119, res_field120, res_field121, res_field122, res_field123, res_field124, res_field125, res_field126, res_field127, res_field128, request, response, extra_data, sync_message) FROM stdin;
\.


--
-- Data for Name: tbl_sys_partners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_partners (date_time_added, added_by, date_time_modified, modified_by, partner_idx, partner_id, setting_profile, partner_name, partner_type, partner_username, partner_password, partner_api_endpoint, allowed_transaction_types, unlock_time, lock_status, partner_status, record_version) FROM stdin;
1585653601	0	1585653601	\N	4	UPESI0005	MONEYTRANS	MONEYTRANS	MONEYTRANS	Jpfrk5qEol	I6jTtlbKwcyTEXi	https://test-networkextensions.moneytrans.eu/v3/PayoutServices.asmx	C,B,M	\N	\N	\N	0
1585653663	0	1585653663	\N	5	SWLU0004	LULU	LULU	LULU	Jpfrk5qEol	I6jTtlbKwcyTEXi	whitelist url ip	C,B,M	\N	\N	\N	0
\.


--
-- Data for Name: tbl_sys_paybills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_paybills (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, paybill_id, setting_profile, paybill_type, api_application_name, api_consumer_key, api_consumer_secret, api_consumer_code, api_endpoint, api_host, shortcode, partnercode, paybill_status, record_version, accountnumber) FROM stdin;
1585721523	0	1585721523	\N	\N	\N	7	LULU	B2C	LULU	Jpfrk5qEol	I6jTtlbKwcyTEXi	\N	http://switchip:9090/switchlink/payments	http://switchip:9090/switchlink/payments	600193	\N	ACTIVE	0	098901221412
1585721625	0	1585721625	\N	\N	\N	8	MONEYTRANS	B2C	UPESI0005	upesiTestPayout	Z1AQS1E5	19900	https://test-networkextensions.moneytrans.eu/v3/PayoutServices.asmx	https://test-networkextensions.moneytrans.eu/v3/PayoutServices.asmx	600193	\N	ACTIVE	0	098901221412
\.


--
-- Data for Name: tbl_sys_references; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_references (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, reference_id, prefix, suffix, anchor_1, anchor_2, anchor_3, reference, record_version) FROM stdin;
1586248438	0	1586248438	\N	\N	\N	3008	\N	\N	tbl_trn_requests	\N	\N	1	0
1586248438	0	1586248438	\N	\N	\N	3009	\N	\N	tbl_trn_transactions	\N	\N	1	0
1586248458	0	1586248458	\N	\N	\N	3010	\N	\N	tbl_trn_requests	\N	\N	2	0
1586248458	0	1586248458	\N	\N	\N	3011	\N	\N	tbl_trn_transactions	\N	\N	2	0
1586248529	0	1586248529	\N	\N	\N	3012	\N	\N	tbl_trn_requests	\N	\N	3	0
1586248529	0	1586248529	\N	\N	\N	3013	\N	\N	tbl_trn_transactions	\N	\N	3	0
1586248622	0	1586248622	\N	\N	\N	3014	\N	\N	tbl_trn_requests	\N	\N	4	0
1586248622	0	1586248622	\N	\N	\N	3015	\N	\N	tbl_trn_transactions	\N	\N	4	0
1586249146	0	1586249146	\N	\N	\N	3016	\N	\N	tbl_trn_requests	\N	\N	5	0
1586249147	0	1586249147	\N	\N	\N	3017	\N	\N	tbl_trn_transactions	\N	\N	5	0
1586343525	0	1586343525	\N	\N	\N	3018	\N	\N	tbl_trn_requests	\N	\N	1	0
1586343525	0	1586343525	\N	\N	\N	3019	\N	\N	tbl_trn_transactions	\N	\N	1	0
1586349223	0	1586349223	\N	\N	\N	3020	\N	\N	tbl_trn_requests	\N	\N	2	0
1586349223	0	1586349223	\N	\N	\N	3021	\N	\N	tbl_trn_transactions	\N	\N	2	0
1586423747	0	1586423747	\N	\N	\N	3022	\N	\N	tbl_trn_requests	\N	\N	1	0
1586430335	0	1586430335	\N	\N	\N	3023	\N	\N	tbl_trn_requests	\N	\N	2	0
1586841447	0	1586841447	\N	\N	\N	3024	\N	\N	tbl_trn_requests	\N	\N	1	0
1586841462	0	1586841462	\N	\N	\N	3025	\N	\N	tbl_trn_requests	\N	\N	2	0
1586846240	0	1586846240	\N	\N	\N	3026	\N	\N	tbl_trn_requests	\N	\N	3	0
1586846240	0	1586846240	\N	\N	\N	3027	\N	\N	tbl_trn_transactions	\N	\N	1	0
1586846316	0	1586846316	\N	\N	\N	3028	\N	\N	tbl_trn_requests	\N	\N	4	0
1586846316	0	1586846316	\N	\N	\N	3029	\N	\N	tbl_trn_transactions	\N	\N	2	0
1586846378	0	1586846378	\N	\N	\N	3030	\N	\N	tbl_trn_requests	\N	\N	5	0
1586846378	0	1586846378	\N	\N	\N	3031	\N	\N	tbl_trn_transactions	\N	\N	3	0
1586846380	0	1586846380	\N	\N	\N	3032	\N	\N	tbl_trn_requests	\N	\N	6	0
1586846380	0	1586846380	\N	\N	\N	3033	\N	\N	tbl_trn_transactions	\N	\N	4	0
1586846381	0	1586846381	\N	\N	\N	3034	\N	\N	tbl_trn_requests	\N	\N	7	0
1586846381	0	1586846381	\N	\N	\N	3035	\N	\N	tbl_trn_transactions	\N	\N	5	0
1586846383	0	1586846383	\N	\N	\N	3036	\N	\N	tbl_trn_requests	\N	\N	8	0
1586846383	0	1586846383	\N	\N	\N	3037	\N	\N	tbl_trn_transactions	\N	\N	6	0
1586846385	0	1586846385	\N	\N	\N	3038	\N	\N	tbl_trn_requests	\N	\N	9	0
1586846385	0	1586846385	\N	\N	\N	3039	\N	\N	tbl_trn_transactions	\N	\N	7	0
1586846386	0	1586846386	\N	\N	\N	3040	\N	\N	tbl_trn_requests	\N	\N	10	0
1586846386	0	1586846386	\N	\N	\N	3041	\N	\N	tbl_trn_transactions	\N	\N	8	0
1586846387	0	1586846387	\N	\N	\N	3042	\N	\N	tbl_trn_requests	\N	\N	11	0
1586846387	0	1586846387	\N	\N	\N	3043	\N	\N	tbl_trn_transactions	\N	\N	9	0
1586846388	0	1586846388	\N	\N	\N	3044	\N	\N	tbl_trn_requests	\N	\N	12	0
1586846388	0	1586846388	\N	\N	\N	3045	\N	\N	tbl_trn_transactions	\N	\N	10	0
1586846389	0	1586846389	\N	\N	\N	3046	\N	\N	tbl_trn_requests	\N	\N	13	0
1586846389	0	1586846389	\N	\N	\N	3047	\N	\N	tbl_trn_transactions	\N	\N	11	0
1586846390	0	1586846390	\N	\N	\N	3048	\N	\N	tbl_trn_requests	\N	\N	14	0
1586846390	0	1586846390	\N	\N	\N	3049	\N	\N	tbl_trn_transactions	\N	\N	12	0
1586846391	0	1586846391	\N	\N	\N	3050	\N	\N	tbl_trn_requests	\N	\N	15	0
1586846391	0	1586846391	\N	\N	\N	3051	\N	\N	tbl_trn_transactions	\N	\N	13	0
1586846487	0	1586846487	\N	\N	\N	3052	\N	\N	tbl_trn_requests	\N	\N	16	0
1586846487	0	1586846487	\N	\N	\N	3053	\N	\N	tbl_trn_transactions	\N	\N	14	0
1586846488	0	1586846488	\N	\N	\N	3054	\N	\N	tbl_trn_requests	\N	\N	17	0
1586846488	0	1586846488	\N	\N	\N	3055	\N	\N	tbl_trn_transactions	\N	\N	15	0
1586846489	0	1586846489	\N	\N	\N	3056	\N	\N	tbl_trn_requests	\N	\N	18	0
1586846489	0	1586846489	\N	\N	\N	3057	\N	\N	tbl_trn_transactions	\N	\N	16	0
1586846492	0	1586846492	\N	\N	\N	3058	\N	\N	tbl_trn_requests	\N	\N	19	0
1586846492	0	1586846492	\N	\N	\N	3059	\N	\N	tbl_trn_transactions	\N	\N	17	0
1586846493	0	1586846493	\N	\N	\N	3060	\N	\N	tbl_trn_requests	\N	\N	20	0
1586846493	0	1586846493	\N	\N	\N	3061	\N	\N	tbl_trn_transactions	\N	\N	18	0
1586846494	0	1586846494	\N	\N	\N	3062	\N	\N	tbl_trn_requests	\N	\N	21	0
1586846494	0	1586846494	\N	\N	\N	3063	\N	\N	tbl_trn_transactions	\N	\N	19	0
1586846495	0	1586846495	\N	\N	\N	3064	\N	\N	tbl_trn_requests	\N	\N	22	0
1586846495	0	1586846495	\N	\N	\N	3065	\N	\N	tbl_trn_transactions	\N	\N	20	0
1586846496	0	1586846496	\N	\N	\N	3066	\N	\N	tbl_trn_requests	\N	\N	23	0
1586846496	0	1586846496	\N	\N	\N	3067	\N	\N	tbl_trn_transactions	\N	\N	21	0
1586846497	0	1586846497	\N	\N	\N	3068	\N	\N	tbl_trn_requests	\N	\N	24	0
1586846497	0	1586846497	\N	\N	\N	3069	\N	\N	tbl_trn_transactions	\N	\N	22	0
1586846498	0	1586846498	\N	\N	\N	3070	\N	\N	tbl_trn_requests	\N	\N	25	0
1586846498	0	1586846498	\N	\N	\N	3071	\N	\N	tbl_trn_transactions	\N	\N	23	0
1586846499	0	1586846499	\N	\N	\N	3072	\N	\N	tbl_trn_requests	\N	\N	26	0
1586846499	0	1586846499	\N	\N	\N	3073	\N	\N	tbl_trn_transactions	\N	\N	24	0
1586846530	0	1586846530	\N	\N	\N	3074	\N	\N	tbl_trn_requests	\N	\N	27	0
1586846530	0	1586846530	\N	\N	\N	3075	\N	\N	tbl_trn_transactions	\N	\N	25	0
1586850452	0	1586850452	\N	\N	\N	3076	\N	\N	tbl_trn_requests	\N	\N	28	0
1586850452	0	1586850452	\N	\N	\N	3077	\N	\N	tbl_trn_transactions	\N	\N	26	0
1586940664	0	1586940664	\N	\N	\N	3078	\N	\N	tbl_trn_requests	\N	\N	1	0
1586940665	0	1586940665	\N	\N	\N	3079	\N	\N	tbl_trn_transactions	\N	\N	1	0
1586940740	0	1586940740	\N	\N	\N	3080	\N	\N	tbl_trn_requests	\N	\N	2	0
1586940740	0	1586940740	\N	\N	\N	3081	\N	\N	tbl_trn_transactions	\N	\N	2	0
1586940745	0	1586940745	\N	\N	\N	3082	\N	\N	tbl_trn_requests	\N	\N	3	0
1586940745	0	1586940745	\N	\N	\N	3083	\N	\N	tbl_trn_transactions	\N	\N	3	0
1586940791	0	1586940791	\N	\N	\N	3084	\N	\N	tbl_trn_requests	\N	\N	4	0
1586940791	0	1586940791	\N	\N	\N	3085	\N	\N	tbl_trn_transactions	\N	\N	4	0
1586941276	0	1586941276	\N	\N	\N	3086	\N	\N	tbl_trn_requests	\N	\N	5	0
1586941276	0	1586941276	\N	\N	\N	3087	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587018035	0	1587018035	\N	\N	\N	3088	\N	\N	tbl_trn_requests	\N	\N	1	0
1587018042	0	1587018042	\N	\N	\N	3089	\N	\N	tbl_trn_requests	\N	\N	2	0
1587026747	0	1587026747	\N	\N	\N	3090	\N	\N	tbl_trn_requests	\N	\N	3	0
1587028517	0	1587028517	\N	\N	\N	3091	\N	\N	tbl_trn_requests	\N	\N	4	0
1587028536	0	1587028536	\N	\N	\N	3092	\N	\N	tbl_trn_requests	\N	\N	5	0
1587028539	0	1587028539	\N	\N	\N	3093	\N	\N	tbl_trn_requests	\N	\N	6	0
1587028539	0	1587028539	\N	\N	\N	3094	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587028541	0	1587028541	\N	\N	\N	3095	\N	\N	tbl_trn_requests	\N	\N	7	0
1587028541	0	1587028541	\N	\N	\N	3096	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587028546	0	1587028546	\N	\N	\N	3097	\N	\N	tbl_trn_requests	\N	\N	8	0
1587028546	0	1587028546	\N	\N	\N	3098	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587028549	0	1587028549	\N	\N	\N	3099	\N	\N	tbl_trn_requests	\N	\N	9	0
1587028549	0	1587028549	\N	\N	\N	3100	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587028746	0	1587028746	\N	\N	\N	3102	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587028795	0	1587028795	\N	\N	\N	3104	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587028912	0	1587028912	\N	\N	\N	3105	\N	\N	tbl_trn_requests	\N	\N	12	0
1587029034	0	1587029034	\N	\N	\N	3108	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587028746	0	1587028746	\N	\N	\N	3101	\N	\N	tbl_trn_requests	\N	\N	10	0
1587028795	0	1587028795	\N	\N	\N	3103	\N	\N	tbl_trn_requests	\N	\N	11	0
1587029034	0	1587029034	\N	\N	\N	3107	\N	\N	tbl_trn_requests	\N	\N	13	0
1587028912	0	1587028912	\N	\N	\N	3106	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587029239	0	1587029239	\N	\N	\N	3109	\N	\N	tbl_trn_requests	\N	\N	14	0
1587029240	0	1587029240	\N	\N	\N	3110	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587029527	0	1587029527	\N	\N	\N	3111	\N	\N	tbl_trn_requests	\N	\N	15	0
1587029527	0	1587029527	\N	\N	\N	3112	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587029528	0	1587029528	\N	\N	\N	3113	\N	\N	tbl_trn_requests	\N	\N	16	0
1587029529	0	1587029529	\N	\N	\N	3114	\N	\N	tbl_trn_requests	\N	\N	17	0
1587029529	0	1587029529	\N	\N	\N	3115	\N	\N	tbl_trn_requests	\N	\N	18	0
1587029530	0	1587029530	\N	\N	\N	3116	\N	\N	tbl_trn_requests	\N	\N	19	0
1587029530	0	1587029530	\N	\N	\N	3117	\N	\N	tbl_trn_requests	\N	\N	20	0
1587029530	0	1587029530	\N	\N	\N	3118	\N	\N	tbl_trn_requests	\N	\N	21	0
1587029530	0	1587029530	\N	\N	\N	3119	\N	\N	tbl_trn_requests	\N	\N	22	0
1587029531	0	1587029531	\N	\N	\N	3120	\N	\N	tbl_trn_requests	\N	\N	23	0
1587029531	0	1587029531	\N	\N	\N	3121	\N	\N	tbl_trn_requests	\N	\N	24	0
1587029532	0	1587029532	\N	\N	\N	3122	\N	\N	tbl_trn_requests	\N	\N	25	0
1587029532	0	1587029532	\N	\N	\N	3123	\N	\N	tbl_trn_requests	\N	\N	26	0
1587029532	0	1587029532	\N	\N	\N	3124	\N	\N	tbl_trn_requests	\N	\N	27	0
1587029533	0	1587029533	\N	\N	\N	3125	\N	\N	tbl_trn_requests	\N	\N	28	0
1587029533	0	1587029533	\N	\N	\N	3126	\N	\N	tbl_trn_requests	\N	\N	29	0
1587029533	0	1587029533	\N	\N	\N	3127	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587029533	0	1587029533	\N	\N	\N	3128	\N	\N	tbl_trn_requests	\N	\N	30	0
1587029533	0	1587029533	\N	\N	\N	3129	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587029534	0	1587029534	\N	\N	\N	3130	\N	\N	tbl_trn_requests	\N	\N	31	0
1587029534	0	1587029534	\N	\N	\N	3131	\N	\N	tbl_trn_transactions	\N	\N	13	0
1587029534	0	1587029534	\N	\N	\N	3132	\N	\N	tbl_trn_requests	\N	\N	32	0
1587029534	0	1587029534	\N	\N	\N	3133	\N	\N	tbl_trn_transactions	\N	\N	14	0
1587029534	0	1587029534	\N	\N	\N	3134	\N	\N	tbl_trn_requests	\N	\N	33	0
1587029534	0	1587029534	\N	\N	\N	3135	\N	\N	tbl_trn_transactions	\N	\N	15	0
1587029534	0	1587029534	\N	\N	\N	3136	\N	\N	tbl_trn_requests	\N	\N	34	0
1587029534	0	1587029534	\N	\N	\N	3137	\N	\N	tbl_trn_transactions	\N	\N	16	0
1587032430	0	1587032430	\N	\N	\N	3138	\N	\N	tbl_trn_requests	\N	\N	35	0
1587032430	0	1587032430	\N	\N	\N	3139	\N	\N	tbl_trn_transactions	\N	\N	17	0
1587032465	0	1587032465	\N	\N	\N	3140	\N	\N	tbl_trn_requests	\N	\N	36	0
1587032465	0	1587032465	\N	\N	\N	3141	\N	\N	tbl_trn_transactions	\N	\N	18	0
1587032506	0	1587032506	\N	\N	\N	3142	\N	\N	tbl_trn_requests	\N	\N	37	0
1587032506	0	1587032506	\N	\N	\N	3143	\N	\N	tbl_trn_transactions	\N	\N	19	0
1587032604	0	1587032604	\N	\N	\N	3144	\N	\N	tbl_trn_requests	\N	\N	38	0
1587032605	0	1587032605	\N	\N	\N	3145	\N	\N	tbl_trn_transactions	\N	\N	20	0
1587032751	0	1587032751	\N	\N	\N	3146	\N	\N	tbl_trn_requests	\N	\N	39	0
1587032751	0	1587032751	\N	\N	\N	3147	\N	\N	tbl_trn_transactions	\N	\N	21	0
1587032759	0	1587032759	\N	\N	\N	3148	\N	\N	tbl_trn_requests	\N	\N	40	0
1587032759	0	1587032759	\N	\N	\N	3149	\N	\N	tbl_trn_transactions	\N	\N	22	0
1587032804	0	1587032804	\N	\N	\N	3150	\N	\N	tbl_trn_requests	\N	\N	41	0
1587032804	0	1587032804	\N	\N	\N	3151	\N	\N	tbl_trn_transactions	\N	\N	23	0
1587032821	0	1587032821	\N	\N	\N	3152	\N	\N	tbl_trn_requests	\N	\N	42	0
1587032821	0	1587032821	\N	\N	\N	3153	\N	\N	tbl_trn_transactions	\N	\N	24	0
1587032968	0	1587032968	\N	\N	\N	3154	\N	\N	tbl_trn_requests	\N	\N	43	0
1587032968	0	1587032968	\N	\N	\N	3155	\N	\N	tbl_trn_transactions	\N	\N	25	0
1587102986	0	1587102986	\N	\N	\N	3156	\N	\N	tbl_trn_requests	\N	\N	1	0
1587102986	0	1587102986	\N	\N	\N	3157	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587102986	0	1587102986	\N	\N	\N	3158	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587102986	0	1587102986	\N	\N	\N	3159	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587103996	0	1587103996	\N	\N	\N	3160	\N	\N	tbl_trn_requests	\N	\N	2	0
1587103996	0	1587103996	\N	\N	\N	3161	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587104770	0	1587104770	\N	\N	\N	3162	\N	\N	tbl_trn_requests	\N	\N	3	0
1587104770	0	1587104770	\N	\N	\N	3163	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587109662	0	1587109662	\N	\N	\N	3164	\N	\N	tbl_trn_requests	\N	\N	4	0
1587109662	0	1587109662	\N	\N	\N	3165	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587109705	0	1587109705	\N	\N	\N	3166	\N	\N	tbl_trn_requests	\N	\N	5	0
1587109705	0	1587109705	\N	\N	\N	3167	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587109775	0	1587109775	\N	\N	\N	3168	\N	\N	tbl_trn_requests	\N	\N	6	0
1587109775	0	1587109775	\N	\N	\N	3169	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587111809	0	1587111809	\N	\N	\N	3170	\N	\N	tbl_trn_requests	\N	\N	7	0
1587111809	0	1587111809	\N	\N	\N	3171	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587112430	0	1587112430	\N	\N	\N	3172	\N	\N	tbl_trn_requests	\N	\N	8	0
1587112430	0	1587112430	\N	\N	\N	3173	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587112447	0	1587112447	\N	\N	\N	3174	\N	\N	tbl_trn_requests	\N	\N	9	0
1587112447	0	1587112447	\N	\N	\N	3175	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587112592	0	1587112592	\N	\N	\N	3176	\N	\N	tbl_trn_requests	\N	\N	10	0
1587112592	0	1587112592	\N	\N	\N	3177	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587113461	0	1587113461	\N	\N	\N	3178	\N	\N	tbl_trn_requests	\N	\N	11	0
1587113461	0	1587113461	\N	\N	\N	3179	\N	\N	tbl_trn_transactions	\N	\N	13	0
1587113473	0	1587113473	\N	\N	\N	3180	\N	\N	tbl_trn_requests	\N	\N	12	0
1587113473	0	1587113473	\N	\N	\N	3181	\N	\N	tbl_trn_transactions	\N	\N	14	0
1587192454	0	1587192454	\N	\N	\N	3182	\N	\N	tbl_trn_requests	\N	\N	1	0
1587192454	0	1587192454	\N	\N	\N	3183	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587192565	0	1587192565	\N	\N	\N	3184	\N	\N	tbl_trn_requests	\N	\N	2	0
1587192565	0	1587192565	\N	\N	\N	3185	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587192628	0	1587192628	\N	\N	\N	3186	\N	\N	tbl_trn_requests	\N	\N	3	0
1587192628	0	1587192628	\N	\N	\N	3187	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587192807	0	1587192807	\N	\N	\N	3188	\N	\N	tbl_trn_requests	\N	\N	4	0
1587192807	0	1587192807	\N	\N	\N	3189	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587193188	0	1587193188	\N	\N	\N	3190	\N	\N	tbl_trn_requests	\N	\N	5	0
1587193188	0	1587193188	\N	\N	\N	3191	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587193189	0	1587193189	\N	\N	\N	3192	\N	\N	tbl_trn_requests	\N	\N	6	0
1587193189	0	1587193189	\N	\N	\N	3193	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587193191	0	1587193191	\N	\N	\N	3194	\N	\N	tbl_trn_requests	\N	\N	7	0
1587193191	0	1587193191	\N	\N	\N	3195	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587193193	0	1587193193	\N	\N	\N	3196	\N	\N	tbl_trn_requests	\N	\N	8	0
1587193193	0	1587193193	\N	\N	\N	3197	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587193194	0	1587193194	\N	\N	\N	3198	\N	\N	tbl_trn_requests	\N	\N	9	0
1587193194	0	1587193194	\N	\N	\N	3199	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587193195	0	1587193195	\N	\N	\N	3200	\N	\N	tbl_trn_requests	\N	\N	10	0
1587193195	0	1587193195	\N	\N	\N	3201	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587193196	0	1587193196	\N	\N	\N	3202	\N	\N	tbl_trn_requests	\N	\N	11	0
1587193197	0	1587193197	\N	\N	\N	3204	\N	\N	tbl_trn_requests	\N	\N	12	0
1587193197	0	1587193197	\N	\N	\N	3205	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587193200	0	1587193200	\N	\N	\N	3208	\N	\N	tbl_trn_requests	\N	\N	14	0
1587193200	0	1587193200	\N	\N	\N	3209	\N	\N	tbl_trn_transactions	\N	\N	14	0
1587193196	0	1587193196	\N	\N	\N	3203	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587193198	0	1587193198	\N	\N	\N	3206	\N	\N	tbl_trn_requests	\N	\N	13	0
1587193198	0	1587193198	\N	\N	\N	3207	\N	\N	tbl_trn_transactions	\N	\N	13	0
1587193201	0	1587193201	\N	\N	\N	3210	\N	\N	tbl_trn_requests	\N	\N	15	0
1587193201	0	1587193201	\N	\N	\N	3211	\N	\N	tbl_trn_transactions	\N	\N	15	0
1587194724	0	1587194724	\N	\N	\N	3212	\N	\N	tbl_trn_requests	\N	\N	16	0
1587194724	0	1587194724	\N	\N	\N	3213	\N	\N	tbl_trn_transactions	\N	\N	16	0
1587195093	0	1587195093	\N	\N	\N	3214	\N	\N	tbl_trn_requests	\N	\N	17	0
1587195093	0	1587195093	\N	\N	\N	3215	\N	\N	tbl_trn_transactions	\N	\N	17	0
1587195580	0	1587195580	\N	\N	\N	3216	\N	\N	tbl_trn_requests	\N	\N	18	0
1587195580	0	1587195580	\N	\N	\N	3217	\N	\N	tbl_trn_transactions	\N	\N	18	0
1587195590	0	1587195590	\N	\N	\N	3218	\N	\N	tbl_trn_requests	\N	\N	19	0
1587195590	0	1587195590	\N	\N	\N	3219	\N	\N	tbl_trn_transactions	\N	\N	19	0
1587195592	0	1587195592	\N	\N	\N	3220	\N	\N	tbl_trn_requests	\N	\N	20	0
1587195592	0	1587195592	\N	\N	\N	3221	\N	\N	tbl_trn_transactions	\N	\N	20	0
1587195593	0	1587195593	\N	\N	\N	3222	\N	\N	tbl_trn_requests	\N	\N	21	0
1587195593	0	1587195593	\N	\N	\N	3223	\N	\N	tbl_trn_transactions	\N	\N	21	0
1587195595	0	1587195595	\N	\N	\N	3224	\N	\N	tbl_trn_requests	\N	\N	22	0
1587195595	0	1587195595	\N	\N	\N	3225	\N	\N	tbl_trn_transactions	\N	\N	22	0
1587195596	0	1587195596	\N	\N	\N	3226	\N	\N	tbl_trn_requests	\N	\N	23	0
1587195596	0	1587195596	\N	\N	\N	3227	\N	\N	tbl_trn_transactions	\N	\N	23	0
1587195597	0	1587195597	\N	\N	\N	3228	\N	\N	tbl_trn_requests	\N	\N	24	0
1587195597	0	1587195597	\N	\N	\N	3229	\N	\N	tbl_trn_transactions	\N	\N	24	0
1587195598	0	1587195598	\N	\N	\N	3230	\N	\N	tbl_trn_requests	\N	\N	25	0
1587195598	0	1587195598	\N	\N	\N	3231	\N	\N	tbl_trn_transactions	\N	\N	25	0
1587195599	0	1587195599	\N	\N	\N	3232	\N	\N	tbl_trn_requests	\N	\N	26	0
1587195599	0	1587195599	\N	\N	\N	3233	\N	\N	tbl_trn_transactions	\N	\N	26	0
1587195600	0	1587195600	\N	\N	\N	3234	\N	\N	tbl_trn_requests	\N	\N	27	0
1587195600	0	1587195600	\N	\N	\N	3235	\N	\N	tbl_trn_transactions	\N	\N	27	0
1587195601	0	1587195601	\N	\N	\N	3236	\N	\N	tbl_trn_requests	\N	\N	28	0
1587195601	0	1587195601	\N	\N	\N	3237	\N	\N	tbl_trn_transactions	\N	\N	28	0
1587195602	0	1587195602	\N	\N	\N	3238	\N	\N	tbl_trn_requests	\N	\N	29	0
1587195602	0	1587195602	\N	\N	\N	3239	\N	\N	tbl_trn_transactions	\N	\N	29	0
1587195847	0	1587195847	\N	\N	\N	3240	\N	\N	tbl_trn_requests	\N	\N	30	0
1587195847	0	1587195847	\N	\N	\N	3241	\N	\N	tbl_trn_transactions	\N	\N	30	0
1587195923	0	1587195923	\N	\N	\N	3242	\N	\N	tbl_trn_requests	\N	\N	31	0
1587195923	0	1587195923	\N	\N	\N	3243	\N	\N	tbl_trn_transactions	\N	\N	31	0
1587195942	0	1587195942	\N	\N	\N	3244	\N	\N	tbl_trn_requests	\N	\N	32	0
1587195942	0	1587195942	\N	\N	\N	3245	\N	\N	tbl_trn_transactions	\N	\N	32	0
1587195966	0	1587195966	\N	\N	\N	3246	\N	\N	tbl_trn_requests	\N	\N	33	0
1587195966	0	1587195966	\N	\N	\N	3247	\N	\N	tbl_trn_transactions	\N	\N	33	0
1587451672	0	1587451672	\N	\N	\N	3248	\N	\N	tbl_trn_requests	\N	\N	1	0
1587451673	0	1587451673	\N	\N	\N	3249	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587451678	0	1587451678	\N	\N	\N	3250	\N	\N	tbl_trn_requests	\N	\N	2	0
1587451679	0	1587451679	\N	\N	\N	3251	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587456466	0	1587456466	\N	\N	\N	3252	\N	\N	tbl_trn_requests	\N	\N	3	0
1587456466	0	1587456466	\N	\N	\N	3253	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587456839	0	1587456839	\N	\N	\N	3254	\N	\N	tbl_trn_requests	\N	\N	4	0
1587456839	0	1587456839	\N	\N	\N	3255	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587459839	0	1587459839	\N	\N	\N	3256	\N	\N	tbl_trn_requests	\N	\N	5	0
1587459839	0	1587459839	\N	\N	\N	3257	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587460724	0	1587460724	\N	\N	\N	3258	\N	\N	tbl_trn_requests	\N	\N	6	0
1587460724	0	1587460724	\N	\N	\N	3259	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587460878	0	1587460878	\N	\N	\N	3260	\N	\N	tbl_trn_requests	\N	\N	7	0
1587460878	0	1587460878	\N	\N	\N	3261	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587461113	0	1587461113	\N	\N	\N	3262	\N	\N	tbl_trn_requests	\N	\N	8	0
1587461113	0	1587461113	\N	\N	\N	3263	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587461191	0	1587461191	\N	\N	\N	3264	\N	\N	tbl_trn_requests	\N	\N	9	0
1587461191	0	1587461191	\N	\N	\N	3265	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587461218	0	1587461218	\N	\N	\N	3266	\N	\N	tbl_trn_requests	\N	\N	10	0
1587461218	0	1587461218	\N	\N	\N	3267	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587461227	0	1587461227	\N	\N	\N	3268	\N	\N	tbl_trn_requests	\N	\N	11	0
1587461227	0	1587461227	\N	\N	\N	3269	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587461857	0	1587461857	\N	\N	\N	3270	\N	\N	tbl_trn_requests	\N	\N	12	0
1587461857	0	1587461857	\N	\N	\N	3271	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587461871	0	1587461871	\N	\N	\N	3272	\N	\N	tbl_trn_requests	\N	\N	13	0
1587461871	0	1587461871	\N	\N	\N	3273	\N	\N	tbl_trn_transactions	\N	\N	13	0
1587461872	0	1587461872	\N	\N	\N	3274	\N	\N	tbl_trn_requests	\N	\N	14	0
1587461872	0	1587461872	\N	\N	\N	3275	\N	\N	tbl_trn_transactions	\N	\N	14	0
1587461874	0	1587461874	\N	\N	\N	3276	\N	\N	tbl_trn_requests	\N	\N	15	0
1587461874	0	1587461874	\N	\N	\N	3277	\N	\N	tbl_trn_transactions	\N	\N	15	0
1587461875	0	1587461875	\N	\N	\N	3278	\N	\N	tbl_trn_requests	\N	\N	16	0
1587461875	0	1587461875	\N	\N	\N	3279	\N	\N	tbl_trn_transactions	\N	\N	16	0
1587461880	0	1587461880	\N	\N	\N	3280	\N	\N	tbl_trn_requests	\N	\N	17	0
1587461880	0	1587461880	\N	\N	\N	3281	\N	\N	tbl_trn_transactions	\N	\N	17	0
1587461881	0	1587461881	\N	\N	\N	3282	\N	\N	tbl_trn_requests	\N	\N	18	0
1587461882	0	1587461882	\N	\N	\N	3283	\N	\N	tbl_trn_requests	\N	\N	19	0
1587461883	0	1587461883	\N	\N	\N	3284	\N	\N	tbl_trn_requests	\N	\N	20	0
1587461895	0	1587461895	\N	\N	\N	3285	\N	\N	tbl_trn_requests	\N	\N	21	0
1587461903	0	1587461903	\N	\N	\N	3286	\N	\N	tbl_trn_requests	\N	\N	22	0
1587462650	0	1587462650	\N	\N	\N	3287	\N	\N	tbl_trn_requests	\N	\N	23	0
1587462742	0	1587462742	\N	\N	\N	3288	\N	\N	tbl_trn_requests	\N	\N	24	0
1587463764	0	1587463764	\N	\N	\N	3289	\N	\N	tbl_trn_requests	\N	\N	25	0
1587463796	0	1587463796	\N	\N	\N	3290	\N	\N	tbl_trn_requests	\N	\N	26	0
1587463801	0	1587463801	\N	\N	\N	3291	\N	\N	tbl_trn_requests	\N	\N	27	0
1587467804	0	1587467804	\N	\N	\N	3292	\N	\N	tbl_trn_requests	\N	\N	28	0
1587491608	0	1587491608	\N	\N	\N	3293	\N	\N	tbl_trn_requests	\N	\N	29	0
1587528997	0	1587528997	\N	\N	\N	3294	\N	\N	tbl_trn_requests	\N	\N	1	0
1587529000	0	1587529000	\N	\N	\N	3295	\N	\N	tbl_trn_requests	\N	\N	2	0
1587536912	0	1587536912	\N	\N	\N	3296	\N	\N	tbl_trn_requests	\N	\N	3	0
1587536912	0	1587536912	\N	\N	\N	3297	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587540704	0	1587540704	\N	\N	\N	3298	\N	\N	tbl_trn_requests	\N	\N	4	0
1587540705	0	1587540705	\N	\N	\N	3299	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587541267	0	1587541267	\N	\N	\N	3300	\N	\N	tbl_trn_requests	\N	\N	5	0
1587541267	0	1587541267	\N	\N	\N	3301	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587627321	0	1587627321	\N	\N	\N	3302	\N	\N	tbl_trn_requests	\N	\N	1	0
1587627321	0	1587627321	\N	\N	\N	3303	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587637726	0	1587637726	\N	\N	\N	3304	\N	\N	tbl_trn_requests	\N	\N	2	0
1587637726	0	1587637726	\N	\N	\N	3305	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587641340	0	1587641340	\N	\N	\N	3306	\N	\N	tbl_trn_requests	\N	\N	3	0
1587641340	0	1587641340	\N	\N	\N	3307	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587645021	0	1587645021	\N	\N	\N	3308	\N	\N	tbl_trn_requests	\N	\N	4	0
1587645021	0	1587645021	\N	\N	\N	3309	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587717663	0	1587717663	\N	\N	\N	3310	\N	\N	tbl_trn_requests	\N	\N	1	0
1587722345	0	1587722345	\N	\N	\N	3311	\N	\N	tbl_trn_requests	\N	\N	2	0
1587722345	0	1587722345	\N	\N	\N	3312	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587722382	0	1587722382	\N	\N	\N	3313	\N	\N	tbl_trn_requests	\N	\N	3	0
1587722382	0	1587722382	\N	\N	\N	3314	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587726999	0	1587726999	\N	\N	\N	3315	\N	\N	tbl_trn_requests	\N	\N	4	0
1587726999	0	1587726999	\N	\N	\N	3316	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587727010	0	1587727010	\N	\N	\N	3317	\N	\N	tbl_trn_requests	\N	\N	5	0
1587727010	0	1587727010	\N	\N	\N	3318	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587727207	0	1587727207	\N	\N	\N	3319	\N	\N	tbl_trn_requests	\N	\N	6	0
1587727208	0	1587727208	\N	\N	\N	3320	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587727376	0	1587727376	\N	\N	\N	3321	\N	\N	tbl_trn_requests	\N	\N	7	0
1587727376	0	1587727376	\N	\N	\N	3322	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587727517	0	1587727517	\N	\N	\N	3323	\N	\N	tbl_trn_requests	\N	\N	8	0
1587727517	0	1587727517	\N	\N	\N	3324	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587728711	0	1587728711	\N	\N	\N	3325	\N	\N	tbl_trn_requests	\N	\N	9	0
1587728711	0	1587728711	\N	\N	\N	3326	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587728719	0	1587728719	\N	\N	\N	3327	\N	\N	tbl_trn_requests	\N	\N	10	0
1587728719	0	1587728719	\N	\N	\N	3328	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587728725	0	1587728725	\N	\N	\N	3329	\N	\N	tbl_trn_requests	\N	\N	11	0
1587728725	0	1587728725	\N	\N	\N	3330	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587728728	0	1587728728	\N	\N	\N	3331	\N	\N	tbl_trn_requests	\N	\N	12	0
1587728728	0	1587728728	\N	\N	\N	3332	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587729144	0	1587729144	\N	\N	\N	3333	\N	\N	tbl_trn_requests	\N	\N	13	0
1587729144	0	1587729144	\N	\N	\N	3334	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587729146	0	1587729146	\N	\N	\N	3335	\N	\N	tbl_trn_requests	\N	\N	14	0
1587729146	0	1587729146	\N	\N	\N	3336	\N	\N	tbl_trn_transactions	\N	\N	13	0
1587729148	0	1587729148	\N	\N	\N	3337	\N	\N	tbl_trn_requests	\N	\N	15	0
1587729148	0	1587729148	\N	\N	\N	3338	\N	\N	tbl_trn_transactions	\N	\N	14	0
1587729150	0	1587729150	\N	\N	\N	3339	\N	\N	tbl_trn_requests	\N	\N	16	0
1587729150	0	1587729150	\N	\N	\N	3340	\N	\N	tbl_trn_transactions	\N	\N	15	0
1587729152	0	1587729152	\N	\N	\N	3341	\N	\N	tbl_trn_requests	\N	\N	17	0
1587729153	0	1587729153	\N	\N	\N	3342	\N	\N	tbl_trn_transactions	\N	\N	16	0
1587729168	0	1587729168	\N	\N	\N	3343	\N	\N	tbl_trn_requests	\N	\N	18	0
1587729168	0	1587729168	\N	\N	\N	3344	\N	\N	tbl_trn_transactions	\N	\N	17	0
1587729178	0	1587729178	\N	\N	\N	3345	\N	\N	tbl_trn_requests	\N	\N	19	0
1587729178	0	1587729178	\N	\N	\N	3346	\N	\N	tbl_trn_transactions	\N	\N	18	0
1587729309	0	1587729309	\N	\N	\N	3347	\N	\N	tbl_trn_requests	\N	\N	20	0
1587729309	0	1587729309	\N	\N	\N	3348	\N	\N	tbl_trn_transactions	\N	\N	19	0
1587729314	0	1587729314	\N	\N	\N	3349	\N	\N	tbl_trn_requests	\N	\N	21	0
1587729314	0	1587729314	\N	\N	\N	3350	\N	\N	tbl_trn_transactions	\N	\N	20	0
1587729318	0	1587729318	\N	\N	\N	3351	\N	\N	tbl_trn_requests	\N	\N	22	0
1587729318	0	1587729318	\N	\N	\N	3352	\N	\N	tbl_trn_transactions	\N	\N	21	0
1587729542	0	1587729542	\N	\N	\N	3353	\N	\N	tbl_trn_requests	\N	\N	23	0
1587729542	0	1587729542	\N	\N	\N	3354	\N	\N	tbl_trn_transactions	\N	\N	22	0
1587729547	0	1587729547	\N	\N	\N	3355	\N	\N	tbl_trn_requests	\N	\N	24	0
1587729547	0	1587729547	\N	\N	\N	3356	\N	\N	tbl_trn_transactions	\N	\N	23	0
1587729550	0	1587729550	\N	\N	\N	3357	\N	\N	tbl_trn_requests	\N	\N	25	0
1587729550	0	1587729550	\N	\N	\N	3358	\N	\N	tbl_trn_transactions	\N	\N	24	0
1587729553	0	1587729553	\N	\N	\N	3359	\N	\N	tbl_trn_requests	\N	\N	26	0
1587729553	0	1587729553	\N	\N	\N	3360	\N	\N	tbl_trn_transactions	\N	\N	25	0
1587729554	0	1587729554	\N	\N	\N	3361	\N	\N	tbl_trn_requests	\N	\N	27	0
1587729555	0	1587729555	\N	\N	\N	3362	\N	\N	tbl_trn_transactions	\N	\N	26	0
1587729557	0	1587729557	\N	\N	\N	3363	\N	\N	tbl_trn_requests	\N	\N	28	0
1587729557	0	1587729557	\N	\N	\N	3364	\N	\N	tbl_trn_transactions	\N	\N	27	0
1587729575	0	1587729575	\N	\N	\N	3365	\N	\N	tbl_trn_requests	\N	\N	29	0
1587729575	0	1587729575	\N	\N	\N	3366	\N	\N	tbl_trn_transactions	\N	\N	28	0
1587729581	0	1587729581	\N	\N	\N	3367	\N	\N	tbl_trn_requests	\N	\N	30	0
1587729581	0	1587729581	\N	\N	\N	3368	\N	\N	tbl_trn_transactions	\N	\N	29	0
1587729583	0	1587729583	\N	\N	\N	3369	\N	\N	tbl_trn_requests	\N	\N	31	0
1587729584	0	1587729584	\N	\N	\N	3370	\N	\N	tbl_trn_transactions	\N	\N	30	0
1587729586	0	1587729586	\N	\N	\N	3371	\N	\N	tbl_trn_requests	\N	\N	32	0
1587729586	0	1587729586	\N	\N	\N	3372	\N	\N	tbl_trn_transactions	\N	\N	31	0
1587729589	0	1587729589	\N	\N	\N	3373	\N	\N	tbl_trn_requests	\N	\N	33	0
1587729589	0	1587729589	\N	\N	\N	3374	\N	\N	tbl_trn_transactions	\N	\N	32	0
1587729593	0	1587729593	\N	\N	\N	3375	\N	\N	tbl_trn_requests	\N	\N	34	0
1587729593	0	1587729593	\N	\N	\N	3376	\N	\N	tbl_trn_transactions	\N	\N	33	0
1587732941	0	1587732941	\N	\N	\N	3377	\N	\N	tbl_trn_requests	\N	\N	35	0
1587732941	0	1587732941	\N	\N	\N	3378	\N	\N	tbl_trn_transactions	\N	\N	34	0
1587733063	0	1587733063	\N	\N	\N	3379	\N	\N	tbl_trn_requests	\N	\N	36	0
1587733063	0	1587733063	\N	\N	\N	3380	\N	\N	tbl_trn_transactions	\N	\N	35	0
1587733112	0	1587733112	\N	\N	\N	3381	\N	\N	tbl_trn_requests	\N	\N	37	0
1587733112	0	1587733112	\N	\N	\N	3382	\N	\N	tbl_trn_transactions	\N	\N	36	0
1587756134	0	1587756134	\N	\N	\N	3383	\N	\N	tbl_trn_requests	\N	\N	38	0
1587756134	0	1587756134	\N	\N	\N	3384	\N	\N	tbl_trn_transactions	\N	\N	37	0
1587756153	0	1587756153	\N	\N	\N	3385	\N	\N	tbl_trn_requests	\N	\N	39	0
1587756153	0	1587756153	\N	\N	\N	3386	\N	\N	tbl_trn_transactions	\N	\N	38	0
1587756182	0	1587756182	\N	\N	\N	3387	\N	\N	tbl_trn_requests	\N	\N	40	0
1587756183	0	1587756183	\N	\N	\N	3388	\N	\N	tbl_trn_transactions	\N	\N	39	0
1587802361	0	1587802361	\N	\N	\N	3389	\N	\N	tbl_trn_requests	\N	\N	1	0
1587802361	0	1587802361	\N	\N	\N	3390	\N	\N	tbl_trn_transactions	\N	\N	1	0
1587803203	0	1587803203	\N	\N	\N	3391	\N	\N	tbl_trn_requests	\N	\N	2	0
1587803203	0	1587803203	\N	\N	\N	3392	\N	\N	tbl_trn_transactions	\N	\N	2	0
1587803743	0	1587803743	\N	\N	\N	3393	\N	\N	tbl_trn_requests	\N	\N	3	0
1587803743	0	1587803743	\N	\N	\N	3394	\N	\N	tbl_trn_transactions	\N	\N	3	0
1587804262	0	1587804262	\N	\N	\N	3395	\N	\N	tbl_trn_requests	\N	\N	4	0
1587804262	0	1587804262	\N	\N	\N	3396	\N	\N	tbl_trn_transactions	\N	\N	4	0
1587807475	0	1587807475	\N	\N	\N	3397	\N	\N	tbl_trn_requests	\N	\N	5	0
1587807475	0	1587807475	\N	\N	\N	3398	\N	\N	tbl_trn_transactions	\N	\N	5	0
1587809041	0	1587809041	\N	\N	\N	3399	\N	\N	tbl_trn_requests	\N	\N	6	0
1587809041	0	1587809041	\N	\N	\N	3400	\N	\N	tbl_trn_transactions	\N	\N	6	0
1587809895	0	1587809895	\N	\N	\N	3401	\N	\N	tbl_trn_requests	\N	\N	7	0
1587809895	0	1587809895	\N	\N	\N	3402	\N	\N	tbl_trn_transactions	\N	\N	7	0
1587810369	0	1587810369	\N	\N	\N	3403	\N	\N	tbl_trn_requests	\N	\N	8	0
1587810369	0	1587810369	\N	\N	\N	3404	\N	\N	tbl_trn_transactions	\N	\N	8	0
1587811943	0	1587811943	\N	\N	\N	3405	\N	\N	tbl_trn_requests	\N	\N	9	0
1587811943	0	1587811943	\N	\N	\N	3406	\N	\N	tbl_trn_transactions	\N	\N	9	0
1587812066	0	1587812066	\N	\N	\N	3407	\N	\N	tbl_trn_requests	\N	\N	10	0
1587812067	0	1587812067	\N	\N	\N	3408	\N	\N	tbl_trn_transactions	\N	\N	10	0
1587812177	0	1587812177	\N	\N	\N	3409	\N	\N	tbl_trn_requests	\N	\N	11	0
1587812177	0	1587812177	\N	\N	\N	3410	\N	\N	tbl_trn_transactions	\N	\N	11	0
1587812625	0	1587812625	\N	\N	\N	3411	\N	\N	tbl_trn_requests	\N	\N	12	0
1587812625	0	1587812625	\N	\N	\N	3412	\N	\N	tbl_trn_transactions	\N	\N	12	0
1587812636	0	1587812636	\N	\N	\N	3413	\N	\N	tbl_trn_requests	\N	\N	13	0
1587812636	0	1587812636	\N	\N	\N	3414	\N	\N	tbl_trn_transactions	\N	\N	13	0
\.


--
-- Data for Name: tbl_sys_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sys_settings (date_time_added, added_by, date_time_modified, modified_by, source_ip, latest_ip, setting_id, setting_profile, setting_name, setting_value, setting_type, setting_status, record_version, deleted_at) FROM stdin;
1586178834	0	1586178834	\N	\N	\N	43	CASHLINK	query_url	http://cashlink:9090/switchlink/transactionStatus	TEXT	ACTIVE	0	\N
1586178850	0	1586178850	\N	\N	\N	44	COREBANKING	url	http://backoffice:22963/api/Utilities/postTransaction	TEXT	ACTIVE	0	\N
1585898635	0	1585898635	\N	\N	\N	16	AML	api_key	3f7f72ad-7ee5-48e5-beb7-c89f6d124dd3	TEXT	ACTIVE	0	\N
1585898848	0	1585898848	\N	\N	\N	18	AML	min_score	90	NUMERIC	ACTIVE	0	\N
1585898881	0	1585898881	\N	\N	\N	19	AML	url	https://search.ofac-api.com/v2	TEXT	ACTIVE	0	\N
1585898942	0	1585898942	\N	\N	\N	20	AML	check_period	30	DAYS	ACTIVE	0	\N
1585898973	0	1585898973	\N	\N	\N	21	AML	check	TRUE	BOOL	ACTIVE	0	\N
1585902749	0	1585902749	\N	\N	\N	23	SYSTEM	T&CS	https://switchlinkafrica.co.ke/	TEXT	ACTIVE	0	\N
1585902777	0	1585902777	\N	\N	\N	24	CRB	source	CREDIT INFO	TEXT	ACTIVE	0	\N
1585902634	0	1585902634	\N	\N	\N	22	BRIDGE	running_services	TRUE	BOOL	ACTIVE	0	\N
1585903515	0	1585903515	\N	\N	\N	25	CUTOFF	time	1500	HOURS	ACTIVE	0	\N
1585903554	0	1585903554	\N	\N	\N	27	Switch	retry	10	MINUTES	ACTIVE	0	\N
1585904549	0	1585904549	\N	\N	\N	28	BRIDGE	host	0.0.0.0	TEXT	ACTIVE	0	\N
1585904583	0	1585904583	\N	\N	\N	29	BRIDGE	port	8502	TEXT	ACTIVE	0	\N
1585904614	0	1585904614	\N	\N	\N	30	PI	url	http://52.20.176.4:8090/api/eftv2/	TEXT	ACTIVE	0	\N
1585904642	0	1585904642	\N	\N	\N	31	PI	username	apiaccount	TEXT	ACTIVE	0	\N
1585904662	0	1585904662	\N	\N	\N	32	PI	password	AuE8u+(	TEXT	ACTIVE	0	\N
1585723265	0	1585723265	\N	\N	\N	13	MONEYTRANS	end_point	https://test-networkextensions.moneytrans.eu/v3/PayoutServices.asmx	TEXT	ACTIVE	0	\N
1585904709	0	1585904709	\N	\N	\N	33	AML	fuzzyscore	70	NUMERIC	ACTIVE	0	\N
1585904763	0	1585904763	\N	\N	\N	34	API	key	Jpfrk5qEol	TEXT	ACTIVE	0	\N
1585904776	0	1585904776	\N	\N	\N	35	API	password	I6jTtlbKwcyTEXi	TEXT	ACTIVE	0	\N
1585904787	0	1585904787	\N	\N	\N	36	API	host	localhost	TEXT	ACTIVE	0	\N
1585904801	0	1585904801	\N	\N	\N	37	API	port	localhost	TEXT	8501	0	\N
1586178914	0	1586178914	\N	\N	\N	45	CASHLINK	request_url	http://cashlink:9090/switchlink/payments	TEXT	ACTIVE	0	\N
1586180266	0	1586180266	\N	\N	\N	48	BRIDGE	xrate_url	http://backoffice:22963/api/Utilities/getExchangeRates?partnerId=15	TEXT	ACTIVE	0	\N
1585733781	0	1585733781	\N	\N	\N	15	MONEYTRANS	api_request_url	http://localhost:8500/api/v1/request	TEXT	ACTIVE	0	\N
1586179308	0	1586179308	\N	\N	\N	46	BRIDGE	query_url	http://superbridge:8501/api/bridge/query/	TEXT	ACTIVE	0	\N
1586179390	0	1586179390	\N	\N	\N	47	BRIDGE	request_url	http://superbridge:8501/api/bridge/request	TEXT	ACTIVE	0	\N
1587190945	0	1587190945	\N	\N	\N	49	API	log_path	/root/moneytransapi/logs/	TEXT	ACTIVE	0	\N
1587195588	0	1587195588	\N	\N	\N	11	MONEYTRANS	access_token_19900	a16443e7-ce1e-4f9c-9a39-0f204a7c8109	TEXT	ACTIVE	86	\N
1587195588	0	1587195588	\N	\N	\N	12	MONEYTRANS	expires_in_19900	1587414673	NUMERIC	ACTIVE	86	\N
1587753215	0	1587753215	\N	\N	\N	57	DISPATCHER	query_url	http://dispatcher:12000/api/v1/transactions/	TEXT	ACTIVE	0	\N
1587753241	0	1587753241	\N	\N	\N	60	DISPATCHER	Api-Password	3tCNb4yd6er0GHd	TEXT	ACTIVE	0	\N
1587753253	0	1587753253	\N	\N	\N	61	DISPATCHER	Api-Key	HTm2RmXjm9	TEXT	ACTIVE	0	\N
1587753225	0	1587753225	\N	\N	\N	58	DISPATCHER	call_back_url	https://dispatcher:12000/api/callback	TEXT	ACTIVE	0	\N
1587753232	0	1587753232	\N	\N	\N	59	DISPATCHER	url	http://dispatcher:12000/api/v1/disbursements	TEXT	ACTIVE	0	\N
\.


--
-- Data for Name: tbl_trn_incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_trn_incidents (date_time_added, added_by, date_time_modified, modified_by, user_activity_log_id, source_ip, latest_ip, incident_id, request_id, request_number, partner_id, partner_name, transaction_ref, transaction_date, collection_branch, transaction_type, service_type, sender_type, sender_full_name, sender_address, sender_city, sender_country_code, sender_currency_code, sender_mobile, send_amount, sender_id_type, sender_id_number, receiver_type, receiver_full_name, receiver_country_code, receiver_currency_code, receiver_amount, receiver_city, receiver_address, receiver_mobile, mobile_operator, receiver_id_type, receiver_id_number, receiver_account, receiver_bank, receiver_bank_code, receiver_swiftcode, receiver_branch, receiver_branch_code, exchange_rate, commission_amount, paybill, remarks, callbacks, original_message, incident_code, incident_note, incident_description, record_version, sent) FROM stdin;
\.


--
-- Data for Name: tbl_trn_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_trn_requests (date_time_added, added_by, date_time_modified, modified_by, user_activity_log_id, source_ip, latest_ip, request_id, request_number, request_hash, request_status, transactions, transactions_value, original_message, record_version) FROM stdin;
1587812625	0	1587812625	\N	\N	\N	\N	1742	200425000012	a8d36929093d57fb6ad7b1af9edb660af7b71bf71deb57bde1c0ee1db6f56e2090933bb6ddfb8c8b21dadb90be74b59116e6d184147f05bbca7625064e254a61	PROCESSING	1	2000	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e36d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	0
1587812636	0	1587812636	\N	\N	\N	\N	1743	200425000013	4af79c9b12c1afc4247af421cbee61eaac4ea7926b9375c4649d1898437104cf630ff2854567ca222022254ae03f488fe83f44883370e457061fdc6152dcaba3	PROCESSING	1	2000	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e336d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	0
\.


--
-- Data for Name: tbl_trn_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_trn_transactions (date_time_added, added_by, date_time_modified, modified_by, user_activity_log_id, source_ip, latest_ip, transaction_id, request_id, request_number, partner_id, partner_name, transaction_ref, transaction_date, collection_branch, transaction_type, service_type, sender_type, sender_full_name, sender_address, sender_city, sender_country_code, sender_currency_code, sender_mobile, send_amount, sender_id_type, sender_id_number, receiver_type, receiver_full_name, receiver_country_code, receiver_currency_code, receiver_amount, receiver_city, receiver_address, receiver_mobile, mobile_operator, receiver_id_type, receiver_id_number, receiver_account, receiver_bank, receiver_bank_code, receiver_swiftcode, receiver_branch, receiver_branch_code, exchange_rate, commission_amount, remarks, paybill, transaction_number, transaction_hash, transaction_status, original_message, transaction_response, switch_response, query_status, query_response, callbacks, callbacks_status, queued_callbacks, completed_callbacks, callback_status, record_version, need_syncing, synced, sent, incident_code, incident_description, incident_note) FROM stdin;
1587812625	0	1587917026	\N	\N	\N	\N	1677	1742	200425000012	SWLU0004	LULU	acd4e36d3dd5	20200325	Nairobi	M	\N	P	Lee KAMAU	JOHN DOE'S ADDRESS	NAIROBI	KEN	USD	2547201	2000	Passport	88998899	P	BEN WERU	KEN	KES	200	NAIROBI	RECIEVER ADDRESS	254708374149	SAFARICOM	Passport	11223344	09809123456	N/A	N/A	EQBLKENA	KANGEMA	N/A	1	0		\N	200425000012	9a5aeb37e23162a4de4be199fef584546d766c2e9d14417c091be5aec8c20dd4515e75f8f90d95e3f4b8d937864ceb1a218b3f4bec5e93f9ab5e894dc51cab88	UPLOADED	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e36d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	Successfully submitted to bridge	Transaction in progress	00	Transaction in progress	[]	\N	0	0	0	2615	f	f	t	\N	\N	\N
1587812636	0	1587917023	\N	\N	\N	\N	1678	1743	200425000013	SWLU0004	LULU	acd4e336d3dd5	20200325	Nairobi	M	\N	P	Lee KAMAU	JOHN DOE'S ADDRESS	NAIROBI	KEN	USD	2547201	2000	Passport	88998899	P	BEN WERU	KEN	KES	200	NAIROBI	RECIEVER ADDRESS	254708374149	SAFARICOM	Passport	11223344	09809123456	N/A	N/A	EQBLKENA	KANGEMA	N/A	1	0		\N	200425000013	8e094e945624c7a14e3b0c3d2d40eb354ee5e80f49081495ad6ee69b7fa861516b497b82caf9e288adbdc97f7c22009233ac2151722b9a0527b2254978e2a0b0	UPLOADED	{entries=[{partner_id=SWLU0004, transaction_ref=acd4e336d3dd5, transaction_date=20200325, collection_branch=Nairobi, transaction_type=M, sender_type=P, sender_full_name=Lee KAMAU, sender_address=JOHN DOE'S ADDRESS, sender_city=NAIROBI, sender_country_code=KEN, sender_currency_code=USD, sender_mobile=2547201, send_amount=2000, sender_id_type=pass, sender_id_number=88998899, receiver_type=P, receiver_full_name=BEN WERU, receiver_country_code=KEN, receiver_currency_code=KES, receiver_amount=200, receiver_city=NAIROBI, receiver_address=RECIEVER ADDRESS, receiver_mobile=254708374149, mobile_operator=SAFARICOM, receiver_id_type=Passport, receiver_id_number=11223344, receiver_account=09809123456, receiver_bank=EQUITY BANK LIMITED, receiver_bank_code=50, receiver_swiftcode=EQBLKENA, receiver_branch_code=003, receiver_branch=KANGEMA, exchange_rate=1, commission_amount=, remarks=, callbacks=[]}]}	Successfully submitted to bridge	Transaction in progress	00	Transaction in progress	[]	\N	0	0	0	2614	f	f	t	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, company_id, role_id, name, contact_person, email, password, msisdn, status, remember_token, created_at, updated_at, deleted_at) FROM stdin;
4	2	2	Caroline Gitonga	Caroline Gitonga	carolgitonga45@gmail.com	$2y$10$WTUzWBK.0CnNqz/tPnHt5uRNekH5k5cGXAdR1xNJVEL3YDUQs68vW	254701154836	ACTIVE	\N	2020-04-27 11:13:11	2020-05-12 08:54:08	\N
2	1	1	Administrator Switchlink	SWITCH LINK	admin@switchlink.co.ke	$2y$10$Jkvwmr2jkI8DcAACSUepSupAF7014mqGvDGdwEOVYlDSBFzNYtMR6	254720711386	ACTIVE	\N	2019-12-17 09:31:57	2020-05-12 09:00:06	\N
5	2	3	Milkah Warui	Milkah Warui	milkah.warui@gmail.com	$2y$10$g7FyVVTnzCMkSyYQbr.J8uUAIyu0NoPmRWJF9wMBFIo/eB9pahmyy	254756189715	ACTIVE	\N	2020-05-08 10:16:26	2020-05-12 09:01:57	\N
6	1	3	Patrick Waweru	Patrick Waweru	patrick.w@gmail.com	$2y$10$vKshF9FweZ/ETlYKfVTlyO./YkK8ahkEgkmPbEjFmK2F/sHURGonm	25437016725	ACTIVE	\N	2020-05-12 13:02:34	2020-05-12 13:02:34	\N
\.


--
-- Data for Name: workflow_stage_approvers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_stage_approvers (id, user_id, granted_by, workflow_stage_id, workflow_stage_type_id, deleted_at, created_at, updated_at) FROM stdin;
1	2	2	1	1	\N	2020-05-12 10:11:24	2020-05-12 10:11:24
\.


--
-- Data for Name: workflow_stage_checklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_stage_checklist (id, name, text, status, workflow_stages_id, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workflow_stage_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_stage_type (id, name, slug, weight, deleted_at, created_at, updated_at) FROM stdin;
1	Upesi	upesi	\N	\N	2020-05-12 10:10:44	2020-05-12 10:10:44
\.


--
-- Data for Name: workflow_stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_stages (id, workflow_stage_type_id, workflow_type_id, weight, deleted_at, created_at, updated_at) FROM stdin;
1	1	1	5	\N	2020-05-12 10:11:03	2020-05-12 10:11:03
\.


--
-- Data for Name: workflow_step_checklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_step_checklist (id, name, user_id, text, status, workflow_steps_id, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workflow_steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_steps (id, workflow_stage_id, workflow_id, user_id, approved_at, rejected_at, weight, deleted_at, created_at, updated_at) FROM stdin;
1	1	1	2	\N	\N	5	\N	2020-05-12 10:13:19	2020-05-12 10:13:19
2	1	2	2	\N	\N	5	\N	2020-05-12 10:17:28	2020-05-12 10:17:28
3	1	3	2	2020-05-12 10:42:54	\N	5	\N	2020-05-12 10:41:06	2020-05-12 10:42:54
4	1	4	2	2020-05-12 10:44:29	\N	5	\N	2020-05-12 10:44:16	2020-05-12 10:44:29
\.


--
-- Data for Name: workflow_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_types (id, name, slug, type, deleted_at, created_at, updated_at) FROM stdin;
1	Transaction Approval	transaction_approval	0	\N	2020-05-12 10:10:21	2020-05-12 10:10:21
\.


--
-- Data for Name: workflows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflows (id, user_id, workflow_type, model_id, model_type, collection_name, payload, sent_by, approved, approved_at, rejected_at, awaiting_stage_id, deleted_at, created_at, updated_at) FROM stdin;
1	4	transaction_approval	1816	App\\Models\\Transactions	transaction_approval	\N	4	0	\N	\N	1	\N	2020-05-12 10:13:19	2020-05-12 10:13:19
2	4	transaction_approval	1816	App\\Models\\Transactions	transaction_approval	\N	4	0	\N	\N	1	\N	2020-05-12 10:17:28	2020-05-12 10:17:28
3	4	transaction_approval	1816	App\\Models\\Transactions	transaction_approval	\N	4	1	2020-05-12 10:42:54	\N	1	\N	2020-05-12 10:41:06	2020-05-12 10:42:54
4	2	transaction_approval	1816	App\\Models\\Transactions	transaction_approval	\N	2	1	2020-05-12 10:44:29	\N	1	\N	2020-05-12 10:44:16	2020-05-12 10:44:29
\.


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_id_seq', 1, false);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 12, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: tbl_adt_user_access_log_user_access_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_adt_user_access_log_user_access_log_id_seq', 1, false);


--
-- Name: tbl_cmp_company_companyid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_cmp_company_companyid_seq', 8, true);


--
-- Name: tbl_cmp_product_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_cmp_product_productid_seq', 1, false);


--
-- Name: tbl_cus_aml_amlid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_cus_aml_amlid_seq', 27324, true);


--
-- Name: tbl_pvd_serviceprovider_serviceproviderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_pvd_serviceprovider_serviceproviderid_seq', 7, true);


--
-- Name: tbl_sec_roles_roleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sec_roles_roleid_seq', 1, false);


--
-- Name: tbl_sys_banks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_banks_id_seq', 1534, true);


--
-- Name: tbl_sys_currencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_currencies_id_seq', 158, true);


--
-- Name: tbl_sys_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_documents_id_seq', 13, true);


--
-- Name: tbl_sys_iso_eod_requests_eod_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_iso_eod_requests_eod_request_id_seq', 1, false);


--
-- Name: tbl_sys_iso_iso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_iso_iso_id_seq', 1816, true);


--
-- Name: tbl_sys_iso_types_iso_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_iso_types_iso_type_id_seq', 1, false);


--
-- Name: tbl_sys_offline_iso_iso_offline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_offline_iso_iso_offline_id_seq', 1, false);


--
-- Name: tbl_sys_partners_partners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_partners_partners_id_seq', 5, true);


--
-- Name: tbl_sys_paybills_paybill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_paybills_paybill_id_seq', 8, true);


--
-- Name: tbl_sys_references_reference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_references_reference_id_seq', 3414, true);


--
-- Name: tbl_sys_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sys_settings_setting_id_seq', 61, true);


--
-- Name: tbl_trn_aml_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_trn_aml_id_seq', 1, false);


--
-- Name: tbl_trn_incidents_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_trn_incidents_incident_id_seq', 1, false);


--
-- Name: tbl_trn_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_trn_requests_request_id_seq', 1743, true);


--
-- Name: tbl_trn_transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_trn_transaction_transaction_id_seq', 1678, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: workflow_stage_approvers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_stage_approvers_id_seq', 1, true);


--
-- Name: workflow_stage_checklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_stage_checklist_id_seq', 1, false);


--
-- Name: workflow_stage_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_stage_type_id_seq', 1, true);


--
-- Name: workflow_stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_stages_id_seq', 1, true);


--
-- Name: workflow_step_checklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_step_checklist_id_seq', 1, false);


--
-- Name: workflow_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_steps_id_seq', 4, true);


--
-- Name: workflow_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_types_id_seq', 1, true);


--
-- Name: workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflows_id_seq', 4, true);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: workflow_types slug_UNIQUE; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_types
    ADD CONSTRAINT "slug_UNIQUE" UNIQUE (slug);


--
-- Name: tbl_adt_user_access_log tbl_adt_user_access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_adt_user_access_log
    ADD CONSTRAINT tbl_adt_user_access_log_pkey PRIMARY KEY (user_access_log_id);


--
-- Name: tbl_cmp_company tbl_cmp_company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_cmp_company
    ADD CONSTRAINT tbl_cmp_company_pkey PRIMARY KEY (companyid);


--
-- Name: tbl_cmp_product tbl_cmp_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_cmp_product
    ADD CONSTRAINT tbl_cmp_product_pkey PRIMARY KEY (productid);


--
-- Name: tbl_cus_blacklist tbl_cus_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_cus_blacklist
    ADD CONSTRAINT tbl_cus_blacklist_pkey PRIMARY KEY (blacklist_id);


--
-- Name: tbl_pvd_serviceprovider tbl_pvd_serviceprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_pvd_serviceprovider
    ADD CONSTRAINT tbl_pvd_serviceprovider_pkey PRIMARY KEY (serviceproviderid);


--
-- Name: tbl_sec_roles tbl_sec_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sec_roles
    ADD CONSTRAINT tbl_sec_roles_pkey PRIMARY KEY (roleid);


--
-- Name: tbl_sys_banks tbl_sys_banks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_banks
    ADD CONSTRAINT tbl_sys_banks_pkey PRIMARY KEY (bank_id);


--
-- Name: tbl_sys_currencies tbl_sys_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_currencies
    ADD CONSTRAINT tbl_sys_currencies_pkey PRIMARY KEY (currency_id);


--
-- Name: tbl_sys_documents tbl_sys_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_documents
    ADD CONSTRAINT tbl_sys_documents_pkey PRIMARY KEY (document_id);


--
-- Name: tbl_sys_iso_eod tbl_sys_iso_eod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_eod
    ADD CONSTRAINT tbl_sys_iso_eod_pkey PRIMARY KEY (eod_id);


--
-- Name: tbl_sys_iso_eod_requests tbl_sys_iso_eod_requests_field37_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_eod_requests
    ADD CONSTRAINT tbl_sys_iso_eod_requests_field37_key UNIQUE (field37);


--
-- Name: tbl_sys_iso_eod_requests tbl_sys_iso_eod_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_eod_requests
    ADD CONSTRAINT tbl_sys_iso_eod_requests_pkey PRIMARY KEY (eod_request_id);


--
-- Name: tbl_sys_iso tbl_sys_iso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso
    ADD CONSTRAINT tbl_sys_iso_pkey PRIMARY KEY (iso_id);


--
-- Name: tbl_sys_iso_types tbl_sys_iso_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso_types
    ADD CONSTRAINT tbl_sys_iso_types_pkey PRIMARY KEY (iso_type_id);


--
-- Name: tbl_sys_offline_iso tbl_sys_offline_iso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_offline_iso
    ADD CONSTRAINT tbl_sys_offline_iso_pkey PRIMARY KEY (iso_id);


--
-- Name: tbl_sys_partners tbl_sys_partner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_partners
    ADD CONSTRAINT tbl_sys_partner_pkey PRIMARY KEY (partner_id);


--
-- Name: tbl_sys_paybills tbl_sys_paybills_api_application_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_paybills
    ADD CONSTRAINT tbl_sys_paybills_api_application_name_key UNIQUE (api_application_name);


--
-- Name: tbl_sys_paybills tbl_sys_paybills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_paybills
    ADD CONSTRAINT tbl_sys_paybills_pkey PRIMARY KEY (paybill_id);


--
-- Name: tbl_sys_references tbl_sys_references_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_references
    ADD CONSTRAINT tbl_sys_references_pkey PRIMARY KEY (reference_id);


--
-- Name: tbl_sys_settings tbl_sys_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_settings
    ADD CONSTRAINT tbl_sys_settings_pkey PRIMARY KEY (setting_id);


--
-- Name: tbl_sys_settings tbl_sys_settings_setting_profile_setting_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_settings
    ADD CONSTRAINT tbl_sys_settings_setting_profile_setting_name_key UNIQUE (setting_profile, setting_name);


--
-- Name: tbl_trn_incidents tbl_trn_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_trn_incidents
    ADD CONSTRAINT tbl_trn_incidents_pkey PRIMARY KEY (incident_id);


--
-- Name: tbl_trn_requests tbl_trn_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_trn_requests
    ADD CONSTRAINT tbl_trn_requests_pkey PRIMARY KEY (request_id);


--
-- Name: tbl_trn_requests tbl_trn_requests_txn_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_trn_requests
    ADD CONSTRAINT tbl_trn_requests_txn_no UNIQUE (request_number);


--
-- Name: tbl_trn_transactions tbl_trn_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_trn_transactions
    ADD CONSTRAINT tbl_trn_transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: tbl_trn_transactions tbl_trn_transactions_txn_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_trn_transactions
    ADD CONSTRAINT tbl_trn_transactions_txn_no UNIQUE (transaction_number);


--
-- Name: tbl_sys_iso unique_ref; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sys_iso
    ADD CONSTRAINT unique_ref UNIQUE (res_field37);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_msisdn_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_msisdn_unique UNIQUE (msisdn);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_stage_approvers workflow_stage_approvers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers
    ADD CONSTRAINT workflow_stage_approvers_pkey PRIMARY KEY (id);


--
-- Name: workflow_stage_checklist workflow_stage_checklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_checklist
    ADD CONSTRAINT workflow_stage_checklist_pkey PRIMARY KEY (id);


--
-- Name: workflow_stage_type workflow_stage_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_type
    ADD CONSTRAINT workflow_stage_type_pkey PRIMARY KEY (id);


--
-- Name: workflow_stages workflow_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stages
    ADD CONSTRAINT workflow_stages_pkey PRIMARY KEY (id);


--
-- Name: workflow_step_checklist workflow_step_checklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_step_checklist
    ADD CONSTRAINT workflow_step_checklist_pkey PRIMARY KEY (id);


--
-- Name: workflow_steps workflow_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_steps
    ADD CONSTRAINT workflow_steps_pkey PRIMARY KEY (id);


--
-- Name: workflow_types workflow_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_types
    ADD CONSTRAINT workflow_types_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: fk_transaction_approval_steps_transaction_approval_stages1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approval_steps_transaction_approval_stages1_idx ON public.workflow_steps USING btree (workflow_stage_id);


--
-- Name: fk_transaction_approval_steps_transaction_approvals1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approval_steps_transaction_approvals1_idx ON public.workflow_steps USING btree (workflow_id);


--
-- Name: fk_transaction_approval_steps_users1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approval_steps_users1_idx ON public.workflow_steps USING btree (user_id);


--
-- Name: fk_transaction_approvals_transaction_approval_stages1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvals_transaction_approval_stages1_idx ON public.workflows USING btree (awaiting_stage_id);


--
-- Name: fk_transaction_approvals_transaction_approval_types1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvals_transaction_approval_types1_idx ON public.workflows USING btree (workflow_type);


--
-- Name: fk_transaction_approvals_users1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvals_users1_idx ON public.workflows USING btree (user_id);


--
-- Name: fk_transaction_approvals_users2_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvals_users2_idx ON public.workflows USING btree (sent_by);


--
-- Name: fk_transaction_approvers_transaction_approval_stages1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvers_transaction_approval_stages1_idx ON public.workflow_stage_approvers USING btree (workflow_stage_type_id);


--
-- Name: fk_transaction_approvers_transaction_approval_stages2_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvers_transaction_approval_stages2_idx ON public.workflow_stage_approvers USING btree (workflow_stage_id);


--
-- Name: fk_transaction_approvers_users1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvers_users1_idx ON public.workflow_stage_approvers USING btree (user_id);


--
-- Name: fk_transaction_approvers_users2_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_transaction_approvers_users2_idx ON public.workflow_stage_approvers USING btree (granted_by);


--
-- Name: fk_workflow_stage_checklist_copy1_workflow_steps1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_workflow_stage_checklist_copy1_workflow_steps1_idx ON public.workflow_step_checklist USING btree (workflow_steps_id);


--
-- Name: fk_workflow_stage_checklist_workflow_stages1_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_workflow_stage_checklist_workflow_stages1_idx ON public.workflow_stage_checklist USING btree (workflow_stages_id);


--
-- Name: media_model_type_model_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX media_model_type_model_id_index ON public.media USING btree (model_type, model_id);


--
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- Name: tbl_cus_blacklist_customer_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_cus_blacklist_customer_name_idx ON public.tbl_cus_blacklist USING btree (customer_name);


--
-- Name: tbl_cus_blacklist_customeridnumber_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_cus_blacklist_customeridnumber_idx ON public.tbl_cus_blacklist USING btree (customer_idnumber);


--
-- Name: tbl_cus_blacklist_customermobile_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_cus_blacklist_customermobile_idx ON public.tbl_cus_blacklist USING btree (mobile_number);


--
-- Name: tbl_password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_password_resets_email_index ON public.tbl_password_resets USING btree (email);


--
-- Name: tbl_password_resets_token_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_password_resets_token_index ON public.tbl_password_resets USING btree (token);


--
-- Name: tbl_sys_iso_eod_requests_field37_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_sys_iso_eod_requests_field37_idx ON public.tbl_sys_iso_eod_requests USING btree (field37);


--
-- Name: tbl_sys_iso_need_sending_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_sys_iso_need_sending_idx ON public.tbl_sys_iso USING btree (need_sending);


--
-- Name: tbl_sys_iso_need_sync_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_sys_iso_need_sync_idx ON public.tbl_sys_iso USING btree (need_sync);


--
-- Name: tbl_sys_iso_sent_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_sys_iso_sent_idx ON public.tbl_sys_iso USING btree (sent);


--
-- Name: tbl_sys_iso_synced_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tbl_sys_iso_synced_idx ON public.tbl_sys_iso USING btree (synced);


--
-- Name: workflow_steps fk_transaction_approval_steps_transaction_approval_stages1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_steps
    ADD CONSTRAINT fk_transaction_approval_steps_transaction_approval_stages1_idx FOREIGN KEY (workflow_stage_id) REFERENCES public.workflow_stages(id);


--
-- Name: workflow_steps fk_transaction_approval_steps_transaction_approvals1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_steps
    ADD CONSTRAINT fk_transaction_approval_steps_transaction_approvals1_idx FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: workflow_steps fk_transaction_approval_steps_users1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_steps
    ADD CONSTRAINT fk_transaction_approval_steps_users1_idx FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workflows fk_transaction_approvals_transaction_approval_stages1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT fk_transaction_approvals_transaction_approval_stages1_idx FOREIGN KEY (awaiting_stage_id) REFERENCES public.workflow_stages(id);


--
-- Name: workflows fk_transaction_approvals_transaction_approval_types1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT fk_transaction_approvals_transaction_approval_types1_idx FOREIGN KEY (workflow_type) REFERENCES public.workflow_types(slug);


--
-- Name: workflows fk_transaction_approvals_users1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT fk_transaction_approvals_users1_idx FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workflows fk_transaction_approvals_users2_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT fk_transaction_approvals_users2_idx FOREIGN KEY (sent_by) REFERENCES public.users(id);


--
-- Name: workflow_stage_approvers fk_transaction_approvers_transaction_approval_stages1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers
    ADD CONSTRAINT fk_transaction_approvers_transaction_approval_stages1_idx FOREIGN KEY (workflow_stage_type_id) REFERENCES public.workflow_stage_type(id);


--
-- Name: workflow_stage_approvers fk_transaction_approvers_transaction_approval_stages2_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers
    ADD CONSTRAINT fk_transaction_approvers_transaction_approval_stages2_idx FOREIGN KEY (workflow_stage_id) REFERENCES public.workflow_stages(id);


--
-- Name: workflow_stage_approvers fk_transaction_approvers_users1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers
    ADD CONSTRAINT fk_transaction_approvers_users1_idx FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workflow_stage_approvers fk_transaction_approvers_users2_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_approvers
    ADD CONSTRAINT fk_transaction_approvers_users2_idx FOREIGN KEY (granted_by) REFERENCES public.users(id);


--
-- Name: workflow_step_checklist fk_workflow_stage_checklist_copy1_workflow_steps1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_step_checklist
    ADD CONSTRAINT fk_workflow_stage_checklist_copy1_workflow_steps1_idx FOREIGN KEY (workflow_steps_id) REFERENCES public.workflow_steps(id);


--
-- Name: workflow_stage_checklist fk_workflow_stage_checklist_workflow_stages1_idx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_stage_checklist
    ADD CONSTRAINT fk_workflow_stage_checklist_workflow_stages1_idx FOREIGN KEY (workflow_stages_id) REFERENCES public.workflow_stages(id);


--
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

