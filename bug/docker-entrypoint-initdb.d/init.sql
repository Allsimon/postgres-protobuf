create schema foo;

-- Protocol Buffer extension for PostgreSQL: https://github.com/mpartel/postgres-protobuf
CREATE EXTENSION postgres_protobuf;

INSERT INTO protobuf_file_descriptor_sets (name, file_descriptor_set)
VALUES ('default', pg_read_binary_file('/tmp/schema.pb'));

CREATE TABLE bar
(
    key   int,
    value bytea
);

-- Insert sample data
INSERT INTO bar (key, value)
VALUES (123456,
        E'\\x0A0608B4E9E2820612A5010A080A063132333435361206080F101018101A4712060880DEAA82061A0608809A94830621000000000000244029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A035341501A3F120608809A948306210000000000002E4029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A0353415029000000000000F0BF12A5010A080A0631323334353612060807100818081A4712060880DEAA82061A0608809A94830621000000000000244029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A035341501A3F120608809A948306210000000000002E4029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A0353415029000000000000F0BF12AD010A0B0A0731323334353637100112060807100818081A4C12060880DEAA82061A0608809A94830621000000000000244029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A086D795573657249641A3F120608809A948306210000000000002E4029000000000000F0BF31000000000000F0BF39000000000000F0BF41000000000000F0BF52034555525A0353415029000000000000F0BF');
