from django.shortcuts import render
from rest_framework import viewsets
from .models import FairyTale
from .serializers import FairyTaleSerializer
from rest_framework.views import APIView
from rest_framework.response import Response

class FairyTaleViewSet(viewsets.ModelViewSet):
    queryset = FairyTale.objects.all()
    serializer_class = FairyTaleSerializer

