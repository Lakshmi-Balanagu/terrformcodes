 Why count is not ideal:
count uses index numbers like 0, 1, 2.

Hard to know which region is at which index.

If the order changes, Terraform may recreate resources.

Naming dashboards like dashboard-${count.index} is confusing.

✅ Why for_each is better:
for_each lets me use region names as keys like ap-south-1, us-east-1.

Easier to create dashboard names like dashboard-ap-south-1.

Clear, readable, and safer — no accidental resource recreation.

Good when each resource is unique, like different regions.
