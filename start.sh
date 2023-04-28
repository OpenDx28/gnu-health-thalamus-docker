# From https://en.wikibooks.org/wiki/GNU_Health/Federation_Technical_Guide#Installing_Thalamus

# "postgres" below is the name of the container running PostgreSQL

# Create a new user thalamus with PostgreSQL permissions
#$ sudo su - postgres -c "createuser --createdb --no-createrole --no-superuser thalamus"

# Initializing PostgreSQL for the HIS and Person Master Index
# Step 1 - Create the Thalamus database
createdb -h thalamus_postgres -U thalamus -w federation
# Step 2 - CD
cd `pip3 show thalamus | grep Location | awk '{$2 = $2 "/thalamus/demo/"; print $2}'`
# Step 3 - Create the Federation HIS schema inside the "demo" directory in Thalamus execute the following SQL script
psql -h thalamus_postgres -d federation < federation_schema.sql
# Step 4 - Set the PostgreSQL URI for demo data
sudo sed -i 's|^PG_URI.*|PG_URI = "postgresql://thalamus:thalamus@thalamus_postgres/federation"|' ./import_pg.py
# Step 5 - Initialize the Federation Demo database
bash ./populate.sh
# Step 6 - Set the postgreSQL URI for runtime

# No further sudo allowed
#sudo apt remove sudo

# Run Thalamus using USWGI
cd ..
sudo cp /home/thalamus/thalamus.cfg etc/thalamus.cfg
sudo cp /home/thalamus/thalamus_uwsgi.ini etc/thalamus_uwsgi.ini
uwsgi --ini etc/thalamus_uwsgi.ini