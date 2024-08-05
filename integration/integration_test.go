//go:build integration

// This is an integration test suite for Sunlight.
//
// It requires a running Sunlight instance to test against, which can be run from
// the included `docker-compose.yml` configuration via `docker compose up` prior
// to running
package integration

import (
	"fmt"
	"io"
	"net/http"
	"testing"
)

// TestPlaceholder doesn't test much, but is just enough to make sure the integration test environment works
// It should be replaced with tests that the sunlight log works.
func TestPlaceholder(t *testing.T) {
	resp, err := http.Get("http://localhost:9000/sunlight-integration/log1/checkpoint")
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Fatalf("failed to read checkpoint, got status %d", resp.StatusCode)
	}

	checkpoint, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatal(err)
	}

	fmt.Printf("it works: %s\n", string(checkpoint))
}
