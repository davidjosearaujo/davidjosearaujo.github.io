#!/bin/bash

# Clean files metadata for privacy
mat2 --inplace static/*

hugo

npx -y pagefind --site "public" --serve