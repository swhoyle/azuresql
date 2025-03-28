from azuresql import Database
from azuresql.auth import AzureCLIAuth

db = Database("myserver", "mydatabase", auth = AzureCLIAuth())
df = db.query()