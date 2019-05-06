# RATS Rampantlly Aggressive Telemetry Server

Send to the specified  address/port a json hash with the format;-

{ "device":"device name","severity":"severity name","data":"whatever the log entry is"}

via UDP, and it'll stuff it into Postgres for you

# SCHEMA 

~~~SQL
CREATE TABLE public.logentries (
    id bigint NOT NULL,
    host character varying(64) NOT NULL,
    severity character varying(16) NOT NULL,
    data text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);

CREATE SEQUENCE public.logentries_sampleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ONLY public.logentries ALTER COLUMN id SET DEFAULT nextval('public.logentries_sampleid_seq'::regclass);

ALTER TABLE ONLY public.logentries
    ADD CONSTRAINT logentries_pkey PRIMARY KEY (id);

~~~

# .etc file

You need a .etc file!

~~~~
HOST=<listen ip address>
PORT=<listen port>
DATABASE=postgres://<username>[:<passwd>]@<hostname>/<dbname>
~~~~
