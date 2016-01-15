
CREATE TABLE brain_feature
(
  id character varying(32) NOT NULL,
  feature_name character varying(32) NOT NULL,
  tissue1_volume numeric NOT NULL,

  CONSTRAINT brain_feature_pkey PRIMARY KEY (id, feature_name)
);

INSERT INTO brain_feature VALUES ('10247', 'Hippocampus_L', 0.0083559);
INSERT INTO brain_feature VALUES ('10247', 'Hippocampus_R', 0.0084571);
INSERT INTO brain_feature VALUES ('10011', 'Hippocampus_L', 0.0090518);

