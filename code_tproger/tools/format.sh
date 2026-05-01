#!/bin/bash

flutter format \
    `find lib -name "*.g.dart" | xargs | tr '\n' ' '` \
    `find lib -name "*.config.dart" | xargs | tr '\n' ' '`