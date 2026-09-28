# Data Model

Conceptual domains derived from the source brief; no physical schema exists yet.

| Domain | Core concepts |
|---|---|
| Identity/access | User, AuthIdentity, Session, Role, Permission, RolePermission, AdminStaffMembership |
| Athlete/coach | AthleteProfile, Goal, AvailabilityRule/Exception, CoachRelationship, CoachNote |
| Consent/data | ConsentGrant, DataConnection, LocalHealthBinding, ImportBatch, SourceRecord, CanonicalActivity, CoverageSnapshot |
| Planning | Strategy, WeeklyPlan/Version, PlannedSession, SessionBlock, Proposal, Adaptation, CompletionReport, SessionMatch |
| AI | AIConnection, CapabilityProfile, DataPolicy, AIJob, UsageRecord, credential reference |
| Catalog | SportFamily/Discipline/Variant, TrainingMethod, SessionPurpose, BodyRegion, MuscleGroup, MovementPattern, EquipmentDefinition, ContentItem/Version, SourceVocabularyEntry, revisioned relations/mappings, rights/review status, CatalogRelease |
| Managed configuration | ConfigDefinition/Revision/Value/Release, FeatureFlag/Revision, MetadataRevision, IntegrationDefinition/Revision/Capability/CapabilityRevision/SourceMapping/Verification, AdminChangeSet, AdminPublishApproval |
| Commerce | BillingProduct, PriceVersion, Membership, EntitlementGrant, PaymentTransaction, FinancialEvent, ProviderEvent, Reconciliation |
| CRM/support | CRMContact, Tag, Interaction, Task, SupportCase, PublicReply, InternalNote |
| Governance | AdminAuditEvent/AuditEvent, OutboxEvent, deletion tombstone, export job, configuration/policy/catalog/mapping versions |

Identity, membership, payment, entitlement, role, and consent are distinct. Money uses exact decimal or explicit source scale. Source provenance and historical plan/content snapshots are immutable; corrections use versioned or reversing records rather than destructive rewriting.

FEAT-002 names conceptual entities, not a required one-table-per-name physical schema. Reuse existing concepts when implementation exists. Published/reference-bearing metadata uses immutable stable IDs/codes and revision/release references; hard delete is limited to safe unreferenced drafts.
