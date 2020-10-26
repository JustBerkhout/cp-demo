CREATE STREAM wikipedia WITH (kafka_topic='wikipedia.parsed', value_format='AVRO');
CREATE STREAM wikipedianobot AS SELECT *, (length->new - length->old) AS BYTECHANGE FROM wikipedia WHERE bot = false;
CREATE STREAM wikipediabot AS SELECT *, (length->new - length->old) AS BYTECHANGE FROM wikipedia WHERE bot = true;
CREATE TABLE en_wikipedia_gt_1 AS SELECT user, 'meta.uri' AS URI, count(*) AS COUNT FROM wikipedia WINDOW TUMBLING (size 300 second) WHERE 'meta.domain' = 'commons.wikimedia.org' GROUP BY user, 'meta.uri' HAVING count(*) > 1;
CREATE STREAM en_wikipedia_gt_1_stream (USER string, URI string, COUNT bigint) WITH (kafka_topic='EN_WIKIPEDIA_GT_1', value_format='AVRO');
CREATE STREAM en_wikipedia_gt_1_counts AS SELECT * FROM en_wikipedia_gt_1_stream where ROWTIME is not null;