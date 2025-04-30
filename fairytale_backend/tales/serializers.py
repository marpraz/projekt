from rest_framework import serializers
from .models import FairyTale

class FairyTaleSerializer(serializers.ModelSerializer):
    class Meta:
        model = FairyTale
        fields = '__all__'