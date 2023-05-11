/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id serial PRIMARY KEY,
    name varchar(100),
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg decimal(5,2),
    species_id BIGINT REFERENCES species (id);
    owner_id BIGINT REFERENCES owners (id);
);

CREATE TABLE owners (
id BIGSERIAL NOT NULL PRIMARY KEY,
full_name varchar(100) NOT NULL,
age INTEGER 
);
CREATE TABLE species (
id BIGSERIAL NOT NULL PRIMARY KEY,
name varchar(100) NOT NULL 
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id BIGINT REFERENCES species (id);
ALTER TABLE animals ADD COLUMN owner_id BIGINT REFERENCES owners (id);


--Create a table named vets
CREATE TABLE vets (
id BIGSERIAL NOT NULL PRIMARY KEY,
name varchar(100),
age INT,
date_of_graduation DATE );

--Create a "join table" called specializations
CREATE TABLE specializations (
	species_id INT,
	vet_id INT
);

--Create a "join table" called visits
CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    date_of_visit DATE
);
