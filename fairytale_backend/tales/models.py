from django.db import models

class FairyTale(models.Model):
    title = models.CharField(max_length=200)
    story = models.TextField()
    tags = models.JSONField()  # Pro tagy, pokud je to JSON

    def __str__(self):
        return self.title