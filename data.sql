/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Agumon', '2020-02-03', 0, true, 10.23);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Gabumon', '2018-11-15', 2, true, 8.0);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Pikachu', '2021-01-07', 1, false, 15.04);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Devimon', '2017-05-12', 5, true, 11.0);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Charmander', DATE '2020-01-08', 0, false, -11);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Plantmon', DATE '2021-11-15', 2, true, -5.7);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Squirtle', DATE '1993-03-02', 3, false, -12.13);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Angemon', DATE '2005-06-12', 1, true, -45);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Boarmon', DATE '2005-06-07', 7, true, 20.4);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Blossom', DATE '1998-10-13', 3, true, 17);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Ditto', DATE '2022-05-14', 4, true, 22);

INSERT INTO owners (full_name, age)
VALUES ('Sam Smith', 34);

INSERT INTO owners (full_name, age)
VALUES ('Jennifer Orwell', 19);

INSERT INTO owners (full_name, age)
VALUES ('Bob', 45);

INSERT INTO owners (full_name, age)
VALUES ('Melody Pond', 77);

INSERT INTO owners (full_name, age)
VALUES ('Dean Winchester', 14);

INSERT INTO owners (full_name, age)
VALUES ('Jodie Whittaker', 38);

INSERT INTO species (name)
VALUES ('Pokemon');

INSERT INTO species (name)
VALUES ('Digimon');

UPDATE animals SET species_id = 2  WHERE name LIKE '%mon';
UPDATE animals SET species_id = 1  WHERE species_id IS NULL;

UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';
UPDATE animals SET owner_id = 2 WHERE name = 'Gabumon' OR name = 'Pikachu';
UPDATE animals SET owner_id = 3 WHERE name = 'Devimon' OR name = 'Plantmon';
UPDATE animals SET owner_id = 4 WHERE name IN ('Charmander', 'Squirtle', 'Blossom');
UPDATE animals SET owner_id = 5 WHERE name IN ('Angemon', 'Boarmon');

--Insert data to vets table:

INSERT INTO vets (name, age, date_of_graduation)
VALUES
  ('William Tatcher', 45, '2000-04-23'),
  ('Maisy Smith', 26, '2019-01-17'),
  ('Stephanie Mendez', 64, '1981-05-04'),
  ('Jack Harkness', 38, '2008-06-08');

--Insert data to specializations table:
    INSERT INTO specializations (species_id, vet_id)
 VALUES ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM species WHERE name = 'Pokemon'));

 INSERT INTO specializations (species_id, vet_id)
 VALUES ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM species WHERE name = 'Pokemon'));

 INSERT INTO specializations (species_id, vet_id)
 VALUES ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM species WHERE name = 'Digimon'));

 INSERT INTO specializations (species_id, vet_id)
 VALUES ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM species WHERE name = 'Digimon'));


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';