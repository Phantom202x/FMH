if psql -U fmh -c "\dt users" 2>&1 | grep  "Did not find any relation named"; then
    echo "Applying schema..."
    psql -f /db-schemas/000-complete.sql
else
    echo Tables already exists. Skipping schema.
fi