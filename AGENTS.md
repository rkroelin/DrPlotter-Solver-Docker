# Repository guidance

## Owner-maintained checkout guidance

<!-- fork: local governance reference; inherited project guidance is preserved. -->
For substantive work, read the shared project standards at `~/Project standards/README.md`, then its `Owner approval.md` and `Delivery gates.md`, followed by this repository's guidance. Use an authorized local or mounted copy; this reference grants no access. Owner approval is limited to infrastructure additions/deletions, permission changes and production deployments; independent agent review covers other changes. Report a refusal without another tool, route or identity.

This is a Docker recipe for a remotely deployed solver. Merging saves what may later be built/deployed; no automatic workflow is present. Runtime auth keys and client tokens belong outside git. No offline test/build runner is established, and no image build/run or tailnet change is authorized by this governance update.

Keep evidence dated with source/version/hash and actual outcomes; distinguish source checks, CI and runtime acceptance. Never record credentials or private runtime stores in evidence. Standards compliance and settings gaps are tracked separately; this file does not authorize a deployment or settings write.
