/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT name, species FROM animals;
ROLLBACK;
SELECT name, species FROM animals;


BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT name, species FROM animals;
COMMIT;
SELECT name, species FROM animals;

-

-- Update the owner_id values in the animals table
UPDATE animals SET owner_id = CASE
WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHEN (name = 'Gabumon' OR name = 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHEN (name = 'Devimon' OR name = 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
WHEN (name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHEN (name = 'Angemon' OR name = 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
DELETE FROM animals WHERE date_of_birth = '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, COUNT(*) FROM animals WHERE escape_attempts > 0 GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

--What animals belong to Melody Pond?
SELECT animals.* FROM animals 
JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';

--List of all animals that are pokemon (their type is Pokemon).
SELECT animals.* FROM animals 
JOIN species ON animals.species_id = species.id WHERE species_id = 1;

--List all owners and their animals, including those that don't own any animal.
SELECT name, full_name FROM animals
LEFT JOIN owners ON animals.owner_id = owners.id;

--How many animals are there per species?
SELECT species.name, COUNT(*) AS animal_count
  FROM animals
  JOIN species
  ON animals.species_id = species.id
  GROUP BY species.name;

--List all Digimon owned by Jennifer Orwell.
SELECT animals.name, owners.full_name, species.name
	FROM animals
	JOIN owners
	ON animals.owner_id = owners.id
	JOIN species
	ON animals.species_id = species.id
	WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

--List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name, animals.escape_attempts
  FROM animals
  JOIN owners
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

--Who owns the most animals?
SELECT owners.full_name, COUNT(*) as count
	FROM animals
	JOIN owners
	ON animals.owner_id = owners.id
	GROUP BY owners.full_name
	ORDER BY count DESC;

--Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, visits.date_of_visit
	FROM animals
	JOIN visits
	ON animals.id = visits.animal_id
	JOIN vets
	ON visits.vet_id = vets.id
	WHERE vets.name = 'William Tatcher'
	ORDER BY visits.date_of_visit DESC
	LIMIT 1;

	--How many animals have been seen by Stephanie Mendez?
	SELECT animals.name, vets.name
		FROM visits
		JOIN animals
		ON animals.id = visits.animal_id
		JOIN vets
		ON vets.id = visits.vet_id
		WHERE vets.name = 'Stephanie Mendez';

--List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
	FROM vets
	LEFT JOIN specializations
	ON vets.id = specializations.vet_id
	LEFT JOIN species
	ON specializations.species_id = species.id;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vets.name, visits.date_of_visit
	FROM animals
	JOIN visits
	ON animals.id = visits.animal_id
	JOIN vets
	ON visits.vet_id = vets.id
	WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

	--what animal has the most visits to vets?

	SELECT animals.name, COUNT(animals.name) AS visit_count
		FROM animals
		JOIN visits
		ON animals.id = visits.animal_id
		GROUP BY animals.name
		ORDER BY visit_count DESC;

--Who was Maisy Smith's first visit?
SELECT animals.name, vets.name, visits.date_of_visit
	FROM animals
	JOIN visits
	ON animals.id = visits.animal_id
	JOIN vets
	ON vets.id = visits.vet_id
	WHERE vets.name = 'Maisy Smith'
	ORDER BY visits.date_of_visit ASC;

--Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.date_of_visit
	FROM animals
	JOIN visits
	ON animals.id = visits.animal_id
	JOIN vets
	ON vets.id = visits.vet_id
	ORDER BY visits.date_of_visit DESC;

	--How many visits were with a vet that did not specialize in that animal's species?
	SELECT COUNT(*)
	FROM visits 
	JOIN (SELECT vets.id
			FROM vets
			FULL JOIN specializations 
		  	ON vets.id = specializations.vet_id
			FULL JOIN species 
		  	ON species.id = specializations.species_id
			WHERE specializations.species_id IS NULL) 
			vet 
	ON vet.id = visits.vet_id;
	
--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(species.name) AS species_count
	FROM animals
	JOIN visits
	ON animals.id = visits.animal_id
	JOIN vets
	ON vets.id = visits.vet_id
	JOIN specializations
	ON vets.id = specializations.vet_id
	JOIN species
	ON specializations.species_id = species.id
	WHERE vets.name = 'Maisy Smith'
	GROUP BY species.name;
	
explain analyze SELECT COUNT(*) FROM visits where animal_id = 4;
explain analyze SELECT * FROM visits where vet_id = 2;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';