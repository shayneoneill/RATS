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
~~~

# .etc file

You need a .etc file!

~~~~
HOST=<listen ip address>
PORT=<listen port>
DATABASE=postgres://<username>[:<passwd>]@<hostname>/<dbname>
~~~~
