#!/bin/bash

# Coverage threshold check script
# Validates that code coverage meets minimum requirements

set -e

# Configuration
MIN_COVERAGE=70
COVERAGE_FILE="coverage/lcov.info"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if lcov.info exists
if [ ! -f "$COVERAGE_FILE" ]; then
  echo -e "${RED}❌ Coverage file not found: $COVERAGE_FILE${NC}"
  echo "Please run 'flutter test --coverage' first"
  exit 1
fi

# Function to calculate coverage percentage
calculate_coverage() {
  # Use English locale for consistent number formatting
  export LC_NUMERIC=C
  export LANG=C
  
  # Use lcov to get summary
  if command -v lcov &> /dev/null; then
    # Parse lcov summary output
    SUMMARY=$(lcov --summary "$COVERAGE_FILE" 2>&1)
    COVERAGE=$(echo "$SUMMARY" | grep "lines" | grep -o '[0-9.]*%' | head -1 | sed 's/%//')
    echo "$COVERAGE"
  else
    # Fallback: Calculate manually from lcov.info
    LINES_FOUND=$(grep -E '^DA:' "$COVERAGE_FILE" | wc -l)
    LINES_HIT=$(grep -E '^DA:' "$COVERAGE_FILE" | grep -v ',0$' | wc -l)
    
    if [ "$LINES_FOUND" -eq 0 ]; then
      echo "0"
    else
      # Calculate percentage
      COVERAGE=$(awk "BEGIN {printf \"%.2f\", ($LINES_HIT/$LINES_FOUND)*100}")
      echo "$COVERAGE"
    fi
  fi
}

# Get current coverage
CURRENT_COVERAGE=$(calculate_coverage)

# Display results
echo ""
echo "================================"
echo "    Coverage Report"
echo "================================"
echo -e "Current coverage: ${YELLOW}${CURRENT_COVERAGE}%${NC}"
echo -e "Minimum required: ${YELLOW}${MIN_COVERAGE}%${NC}"
echo "================================"
echo ""

# Compare with threshold
if command -v bc &> /dev/null; then
  # Use bc for precise comparison
  RESULT=$(echo "$CURRENT_COVERAGE >= $MIN_COVERAGE" | bc -l)
else
  # Fallback: Use awk
  RESULT=$(awk -v curr="$CURRENT_COVERAGE" -v min="$MIN_COVERAGE" 'BEGIN {print (curr >= min)}')
fi

# Check result
if [ "$RESULT" -eq 1 ]; then
  echo -e "${GREEN}✅ Coverage check passed!${NC}"
  echo -e "${GREEN}Coverage of ${CURRENT_COVERAGE}% meets the minimum requirement of ${MIN_COVERAGE}%${NC}"
  exit 0
else
  echo -e "${RED}❌ Coverage check failed!${NC}"
  echo -e "${RED}Coverage of ${CURRENT_COVERAGE}% is below minimum requirement of ${MIN_COVERAGE}%${NC}"
  echo ""
  echo "Please add more tests to increase coverage."
  exit 1
fi
