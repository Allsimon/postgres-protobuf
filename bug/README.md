In order to reproduce locally:

```shell
git clone -b bug/reproduction git@github.com:Allsimon/postgres-protobuf.git
cd postgres-protobuf/bug
docker build . -t bug_repro
docker run  -it --rm --name some-postgres -e POSTGRES_PASSWORD=pass bug_repro psql

# In another terminal, run:
# the password is 'pass' 
docker exec -ti some-postgres psql -h localhost -U postgres -W
```

This query:
```sql
postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*]', value) from bar;

protobuf_query                                                                                                                                                                                                                                               
                
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------
 {"entityIdentifier":{"code":"123456"},"tier":{"type":15,"code":16,"subCode":16},"prices":[{"startDate":{"timestamp":"1615507200"},"endDate":{"timestamp":"1617235200"},"valueWithTaxes":10,"valueWithoutTaxes":-1,"referenceValueWithTaxes":-1,"referenceValu
eWithoutTaxes":-1,"margin":-1,"currency":"EUR","userId":"SAP"},{"startDate":{"timestamp":"1617235200"},"valueWithTaxes":15,"valueWithoutTaxes":-1,"referenceValueWithTaxes":-1,"referenceValueWithoutTaxes":-1,"margin":-1,"currency":"EUR","userId":"SAP"}],"
saleAtLoss":-1}
(1 row)
```

beautified and with useless data removed:
```json
{
  ...
  "prices": [
    {
      "valueWithTaxes": 10,
      ...
    },
    {
      "valueWithTaxes": 15,
      ...
    }
  ]
}
```

Those queries seems to returns wrong data:
```
# Price with `valueWithTaxes` is missing

postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*].prices[*]', value) from bar;
                                                                                                          protobuf_query                                                                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 {"startDate":{"timestamp":"1615507200"},"endDate":{"timestamp":"1617235200"},"valueWithTaxes":10,"valueWithoutTaxes":-1,"referenceValueWithTaxes":-1,"referenceValueWithoutTaxes":-1,"margin":-1,"currency":"EUR","userId":"SAP"}
(1 row)
```

```
# No idea what's happening with the indexes here...

postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*].prices[0].value_with_taxes', value) 
from bar;
 protobuf_query 
----------------
 
(1 row)

postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*].prices[1].value_with_taxes', value) 
from bar;
 protobuf_query 
----------------
 
(1 row)

postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*].prices[2].value_with_taxes', value) 
from bar;
 protobuf_query 
----------------
 10.000000
(1 row)

postgres=# SELECT protobuf_query('PActualPriceValue:timelines[*].prices[3].value_with_taxes', value) 
from bar;
 protobuf_query 
----------------
 15.000000
(1 row)
```
