# How To Run
First, export the required environment variables.

```bash
export NEW_RELIC_ACCOUNT_ID=3588847
export NEW_RELIC_API_KEY=NRAK-XXXXXXXXXXXXXXXXXX
```

Next, define the widgets
```sql
#BillBoard
FROM Transaction SELECT count(*) as 'Total transactions', average(duration) as 'Avg duration (s)', percentile(duration, 90) as 'Slowest 10% (s)', percentage(count(*), WHERE error is false) AS 'Success rate' SINCE 1 WEEK AGO

# Stacked Bar
SELECT average(apm.service.overview.web) * 1000 FROM Metric WHERE (appName='app01') FACET `segmentName` LIMIT MAX SINCE 3600 seconds AGO TIMESERIES 

# Table
SELECT * FROM Log
```

Finally, run the following command to deploy the dashboard.

```bash
terragrunt init -reconfigure
terragrunt plan -out out.tfplan
terragrunt apply out.tfplan
```
