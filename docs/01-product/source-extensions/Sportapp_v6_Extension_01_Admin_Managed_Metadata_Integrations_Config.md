# Sportapp v6 — Extension 01
## Web Admin Managed Metadata, Taxonomy, Integrations & Runtime Configuration

**Belge tipi:** Mevcut v6 gereksinim dokümanına DELTA / EXTENSION  
**Amaç:** Mevcut geliştirmeyi baştan yaptırmadan, uygulamadaki metadata, spor taksonomisi, içerik sınıflandırmaları, entegrasyon görünürlüğü/aktifliği ve mümkün olan çalışma parametrelerini Web Admin üzerinden yönetilebilir hale getirmek.  
**Önemli:** Bu belge v6'yı değiştirmez veya tekrar uygulatmaz. Mevcut kodu ve tamamlanan işleri koru; yalnızca bu extension'ın gerektirdiği farkları uygula.

---

# 0. Kodlama LLM’ine bağlayıcı talimat

Mevcut Sportapp v6 dokümanı ve bugüne kadar geliştirdiğin kod **source of truth** olmaya devam eder.

Bu extension için:

1. **Projeyi baştan kurma veya v6 işlerini tekrar yazma.**
2. Önce mevcut kodu tara ve aşağıdaki alanlardan hangilerinin hard-coded enum, static JSON, config dosyası, environment variable, database kaydı, remote config veya provider adapter sabiti olarak tutulduğunu çıkar.
3. Bunlardan güvenli şekilde admin tarafından yönetilebilir olanları **database-backed, versioned configuration** haline getir.
4. Mevcut ID'leri, kullanıcı geçmişini, planları ve activity kayıtlarını bozma.
5. Bir metadata kaydının adını/değerini değiştirmek geçmiş planların anlamını geriye dönük değiştirmemeli.
6. Admin panelinden yapılan bir değişiklik doğrudan production'a körlemesine yansımamalı: **Draft → Validate → Publish → Active → Superseded/Rolled Back** yaşam döngüsü kullan.
7. Güvenlik, sağlık verisi erişimi, App Store entitlement'ları veya kaynak platformun teknik olarak izin vermediği bir özellik admin panelindeki toggle ile mümkün hale gelmiş gibi gösterilmemeli.
8. Admin panelindeki config hiçbir zaman authentication, authorization, health-data consent, secret management veya safety validation kontrollerini bypass edemez.
9. Değişikliklerin tamamı audit log'a yazılır.
10. Uygulama admin config servisine ulaşamazsa son geçerli published config ile güvenli şekilde devam eder.

---

# 1. Yeni temel ürün kararı

Sportapp içindeki ürün metadata'sının mümkün olan bölümü kod içine gömülü sabitlerden yönetilen metadata'ya dönüştürülecektir.

Web Admin, aşağıdaki alanların ana yönetim yüzeyidir:

- spor türleri,
- spor aileleri,
- spor kategorileri,
- alt sporlar ve varyantlar,
- workout/training method'ları,
- session purpose'ları,
- hareket/drill/poz katalogları,
- kas grupları,
- vücut bölgeleri,
- movement pattern'ları,
- ekipman/aparatlar,
- seviye etiketleri,
- kullanıcıya gösterilen isimler, açıklamalar, sıralama ve görünürlük,
- entegrasyon tanımları,
- entegrasyonların aktif/pasif durumu,
- provider capability bilgileri,
- veri tipi destek matrisi,
- kaynak uygulama → Sportapp eşlemeleri,
- uygulama içi feature/config parametrelerinin güvenli alt kümesi,
- AI provider metadata'sı ve görev yetenekleri,
- katalog/config sürümleri ve yayın durumu.

Admin paneli **source code editor veya limitsiz rules engine değildir**.

---

# 2. Yönetilecek metadata alanları

## 2.1 SportFamily

Örnek: Endurance, Strength, Mind & Body, Functional/Hybrid, Team Sports, Racquet Sports, Combat, Outdoor, Water, Winter, Dance/Gymnastics.

Alanlar:

- `id`
- `code` — immutable/stable internal key
- `name`
- `localized_names`
- `description`
- `icon_key`
- `sort_order`
- `is_active`
- `is_user_selectable`
- `is_plan_supported`
- `is_ai_planning_supported`
- `is_adaptation_supported`
- `visibility_scope`
- `valid_from`
- `valid_to`
- `version`
- `source`
- `review_status`

## 2.2 SportDiscipline

Örnek: Running, Strength Training, Pilates, HIIT, Functional Training, Swimming, Tennis, Basketball, Yoga, Cycling.

Alanlar:

- stable code
- parent SportFamily
- aliases
- localizations
- icon
- ordering
- active/inactive
- searchable
- selectable
- plan capability
- adaptation capability
- manual-plan-only flag
- required metadata schema
- source mappings
- version/review status

## 2.3 SportVariant / SubSport

Örnek:

- Running → Road / Trail / Treadmill
- Cycling → Indoor / Road / MTB
- Pilates → Mat / Reformer
- Swimming → Pool / Open Water
- Strength → Bodybuilding / Powerlifting / General Strength

Admin işlemleri:

- create
- edit
- deactivate
- reorder
- map/unmap
- merge proposal
- deprecate
- replacement mapping

**Silme yerine varsayılan davranış deactivation/deprecation olmalıdır.**

---

# 3. Egzersiz / hareket / drill / poz metadata yönetimi

## ContentItem / ExerciseDefinition

Alanlar:

- stable internal ID
- canonical name
- TR/EN ve ileride diğer diller
- aliases / search synonyms
- content type: exercise, drill, pose, stretch, skill, station, movement
- sport discipline(s)
- body region(s)
- primary muscle group(s)
- secondary muscle group(s)
- movement pattern(s)
- equipment/apparatus
- difficulty/level
- unilateral/bilateral
- body position
- exercise intent / purpose
- supported prescription fields
- contraindication/safety metadata reference
- source vocabulary reference
- Garmin/FIT source mappings where applicable
- status: `SOURCE_ONLY`, `DRAFT`, `REVIEW_REQUIRED`, `APPROVED`, `ACTIVE`, `DEPRECATED`, `WITHDRAWN`
- `automatic_prescription_eligible`
- `manual_plan_eligible`
- `ai_visible`
- sort/search metadata
- content version

### Kuvvet için filtre yönetimi

Admin en az şu kategorileri yönetebilmelidir:

Back, Chest, Shoulders, Arms, Biceps, Triceps, Forearms, Legs, Quadriceps, Hamstrings, Glutes, Calves, Core, Full Body.

Bunlar kullanıcıya gösterilen sabit enum'lar olmamalı; stable code + managed display metadata kullanılmalı.

### Branşa özel metadata

- Pilates: mat/reformer/apparatus, body position, movement family
- Yoga: pose family, flow, hold, balance
- Swimming: stroke, drill, distance type
- HIIT: EMOM, AMRAP, Tabata, circuit, work/rest pattern
- Functional: squat/hinge/push/pull/carry/rotate/locomotion
- Tennis: serve/return/groundstroke/footwork/rally
- Basketball: shooting/passing/dribbling/defense/conditioning

Yeni bir branş eklenebilmesi için mümkün olduğunca DB migration gerekmemeli; yapı metadata/schema-driven olmalıdır.

---

# 4. Metadata ilişkileri admin panelinden yönetilebilmeli

Many-to-many ilişkiler:

- sport ↔ family
- sport ↔ variant
- sport ↔ training method
- sport ↔ session purpose
- sport ↔ equipment
- content item ↔ sport
- content item ↔ muscle group
- content item ↔ body region
- content item ↔ movement pattern
- content item ↔ equipment
- source vocabulary item ↔ canonical Sportapp item
- imported external sport type ↔ Sportapp canonical sport type

Mapping değişikliği geçmiş veriyi mutate etmez.

Yeni mapping yeni importlara uygulanabilir. Eski aktiviteler için reclassification gerekiyorsa ayrı preview/diff ve audit'li job kullanılmalıdır.

---

# 5. Web Admin — Metadata ekranları

## 5.1 Sports Catalog

- family list
- sport list
- variant list
- active/inactive
- plan support
- AI support
- ordering
- localization
- source mapping
- draft/published state

## 5.2 Exercise / Content Catalog

- full text search
- filters
- muscle/body region
- sport
- equipment
- review status
- source
- active state
- AI prescription eligibility

## 5.3 Taxonomy Manager

Tree-only UI zorunlu değildir; graph/relationship yönetimi desteklenmeli.

- canonical records
- aliases
- mappings
- merge candidate
- deprecated → replacement
- unmapped source records

## 5.4 Localization Manager

TR, EN ve ileride diğer diller için:

- display name
- description
- aliases

Stable internal code translation ile değişmez.

## 5.5 Catalog Release

- draft
- validation result
- diff
- publish
- rollback
- previous versions
- audit log

---

# 6. Integration Registry — tüm entegrasyonlar Web Admin’den görünür ve yönetilebilir

Merkezi bir **Integration Registry** oluştur.

Kapsam örnekleri:

- Apple Health / HealthKit
- Google Health
- Huawei Health
- Samsung Health
- ileride eklenecek fitness/health uygulamaları
- Apple Login
- Google Login
- Platform LLM
- BYOK-supported AI providers
- push/notification provider
- billing/payment providers
- email provider
- gelecekte calendar vb.

Her provider aynı config şemasını kullanmak zorunda değildir.

---

# 7. IntegrationDefinition modeli

Her entegrasyon için en az:

- `id`
- `provider_code` — stable/immutable
- `display_name`
- `category`
- `platform`
- `integration_mode`
  - `local_os_api`
  - `oauth_account_api`
  - `relay_via_apple_health`
  - `backend_api`
  - `auth_provider`
  - `ai_provider`
  - `payment_provider`
- `environment`
- `is_configured`
- `is_enabled`
- `is_visible_to_user`
- `is_new_connection_allowed`
- `existing_connections_behavior`
- `support_status`
  - `ACTIVE`
  - `BETA`
  - `PARTIAL`
  - `DISABLED`
  - `BLOCKED_EXTERNAL`
  - `UNSUPPORTED_ON_IOS`
  - `NEEDS_VERIFICATION`
  - `DEPRECATED`
- `capability_profile`
- `minimum_ios_version` if applicable
- `provider_app_min_version` if known
- `documentation_url/reference`
- `last_verified_at`
- `last_verified_by`
- `config_version`
- `maintenance_message`
- `user_facing_message`
- `sort_order`

---

# 8. Integration aktif / pasif davranışı

Tek `enabled` toggle kullanma.

Ayrı kontroller:

### `is_visible_to_user`
Entegrasyon seçim ekranında gösterilsin mi?

### `is_new_connection_allowed`
Yeni bağlantı açılabilsin mi?

### `existing_connections_behavior`

- `KEEP_RUNNING`
- `READ_ONLY_EXISTING`
- `PAUSE_SYNC`
- `REQUIRE_REAUTH`
- `DISABLE_ALL`

### `is_enabled`
Backend adapter işleri çalışabilsin mi?

### `maintenance_mode`
Geçici bakım durumu.

### `support_status`
Kullanıcıya destek seviyesi.

Örnek: Samsung Health iOS üzerinde `UNSUPPORTED_ON_IOS` ise admin toggle bunu teknik olarak desteklenen hale getiremez.

---

# 9. Veri tipi / capability matrisi admin’den yönetilebilir

Her entegrasyon için veri kategorileri ayrı yönetilmeli:

- workouts / activities
- workout type
- duration
- distance
- heart rate summary
- heart rate samples
- resting heart rate
- HRV
- sleep duration
- sleep stages
- VO2max
- calories burned
- nutrition consumed
- steps
- body weight
- body composition
- training load if source exposes it
- future metrics

Her capability durumu:

- supported
- unsupported
- partial
- unknown
- disabled_by_product
- blocked_by_provider

Ek alanlar:

- source data type
- Sportapp canonical metric
- read direction
- history availability
- freshness expectations
- permission requirement
- AI usage allowed?
- coach visibility allowed?
- normalization rule version
- last tested at

**Admin bir provider'ın gerçekte desteklemediği veri tipini supported yaparak teknik gerçeği aşamaz.** Publish validation capability'nin doğrulanmış üst sınırını kontrol etmelidir.

---

# 10. Kaynak uygulama → canonical data mapping yönetimi

Admin panelinde:

- external source name/code
- source sport/activity type
- source metric
- canonical Sportapp type
- confidence / review state
- active mapping
- mapping version
- fallback behavior

yönetilebilmelidir.

Örnek:

`Huawei Health Outdoor Run → Sportapp Running / Road / Outdoor`

`Apple Health functionalStrengthTraining → Sportapp Strength / Functional Strength`

Mapping hata yaptığında ham kaynak kayıt değişmez.

---

# 11. Runtime Product Configuration

Web Admin'den değiştirilebilecek parametreler güvenli bir **Product Configuration Registry** altında tutulmalıdır.

## Planlama

- max active goals
- default planning horizon
- first-plan history window
- allowed weekly-plan length
- automatic minor adaptation availability
- approval thresholds
- stale-data thresholds — yalnız validated range içinde
- plan generation timeout
- retry count
- user-facing regenerate limit

## AI

- platform AI provider active/inactive
- model alias
- supported task types
- max context policy
- timeout
- retry
- task-level usage caps
- BYOK enabled/disabled
- custom endpoint enabled/disabled
- provider display metadata

## Catalog

- default catalog release
- sport visibility
- search ranking weights within validated limits
- content review requirement
- localization fallback

## Integration

- visible
- connectable
- enabled
- maintenance
- supported data categories
- refresh/sync policy within provider/OS capabilities
- retry/backoff within validated limits

## UX

- selected onboarding modules
- optional onboarding questions
- feature visibility
- informational banners
- maintenance notices

---

# 12. Admin’den DEĞİŞTİRİLEMEYECEK şeyler

Remote config haline getirme:

- authentication bypass
- authorization/RBAC enforcement
- başka sporcunun verisine erişim
- HealthKit entitlement
- Apple signing capability
- iOS sandbox kuralları
- App Store mandatory behavior
- cryptographic algorithms
- encryption keys/secrets in plain text
- tenant/user isolation database constraints
- consent enforcement
- safety-critical hard limits without validated bounds
- unsupported external API creation
- provider terms-of-use bypass
- measurement/sensor/device integration scope
- arbitrary code/script execution
- arbitrary SQL
- policy/permissions bypass eden arbitrary LLM system prompt
- arbitrary privileged backend URL/headers

Bu kurallar code/server policy seviyesinde kalır.

---

# 13. Config schema ve tip güvenliği

Key-value çöplüğüne dönüşmemeli.

Her configurable item:

- key
- namespace
- data type
- default
- min/max
- enum choices
- validation
- environment scope
- visibility
- requires restart?
- requires app release?
- hot reload supported?
- sensitive?
- editable roles
- description
- current version

taşır.

Örnek:

```json
{
  "key": "planning.max_active_goals",
  "type": "integer",
  "min": 1,
  "max": 10,
  "default": 3,
  "hot_reload": true
}
```

---

# 14. Config scope

- GLOBAL
- ENVIRONMENT: development / staging / production
- PLATFORM: ios / admin_web
- APP_VERSION_RANGE
- IOS_VERSION_RANGE
- COUNTRY/REGION — gerçekten gerekliyse
- USER_SEGMENT — yalnız genel rollout için; sağlık verisine göre reklam/segmentasyon amacıyla değil

Öncelik çözümleme deterministik olmalıdır.

---

# 15. Feature Flag sistemi

Örnek:

- `feature.byok`
- `feature.coach_mode`
- `feature.pilates_ai_planning`
- `feature.google_health_account_api`
- `feature.samsung_health_ios`
- `feature.new_catalog_search`

Her flag:

- default state
- environment
- app version constraints
- rollout percentage if supported
- optional start/end date
- owner
- reason
- audit
- rollback

Feature flag backend permission check yerine kullanılamaz.

---

# 16. Draft / Validate / Publish mimarisi

Durum:

`DRAFT → VALIDATING → READY_TO_PUBLISH → ACTIVE → SUPERSEDED`

Hatalı:

`VALIDATION_FAILED`

Rollback:

`ACTIVE → ROLLED_BACK`

Publish öncesi kontroller:

- referential integrity
- duplicate stable code
- missing localization
- orphan relation
- invalid capability
- unsupported integration flag
- dangerous parameter range
- published plan compatibility
- minimum app schema version
- migration requirement
- secret leakage

---

# 17. iPhone App config tüketimi

iPhone uygulaması:

1. login sonrasında config snapshot alır,
2. ETag/version ile cache eder,
3. kullandığı config sürümünü bilir,
4. ağ yoksa son geçerli published snapshot ile çalışır,
5. config bozuksa bundled safe defaults'a düşer,
6. taslak config'i asla görmez,
7. tanımadığı yeni alanı ignore eder; kritik schema incompatibility varsa güvenli fallback uygular.

Backend karar motoru da published config sürümünü kullanmalıdır.

Plan oluştururken kullanılan önemli config/catalog sürümleri `DecisionRecord` içine kaydedilmelidir.

---

# 18. Metadata değişiminin tarihsel veriye etkisi

**Admin bir sporun, hareketin veya kategorinin adını/değerini değiştirdiğinde geçmiş plan ve aktivite anlamı sessizce değişmemelidir.**

Tutulacaklar:

- stable ID
- immutable code
- versioned display metadata
- plan içinde `ContentSnapshot`
- activity canonical mapping version
- decision record catalog/config version

Silme yerine:

- deactivate
- deprecate
- replace

Hard delete yalnız hiç referans almamış güvenli draft içerikte düşünülebilir.

---

# 19. Web Admin yeni ekran seti

Mevcut v6 Admin Panel'e ekle:

## Configuration
- Product Configuration
- Feature Flags
- Environment Overrides
- Published Config History
- Diff / Rollback

## Metadata
- Sports
- Sport Families
- Sport Variants
- Training Methods
- Session Purposes
- Body Regions
- Muscle Groups
- Movement Patterns
- Equipment
- Levels
- Units if product-managed

## Content
- Exercises
- Drills
- Poses
- Stations
- Aliases
- Source mappings
- Review queue

## Integrations
- Integration Registry
- Provider detail
- Capability matrix
- Active/Inactive controls
- Data type mappings
- Maintenance mode
- Verification history

## Release Management
- Draft changes
- validation failures
- diff preview
- scheduled publish optional
- publish
- rollback
- audit

---

# 20. Admin RBAC

Örnek yetkiler:

- `ADMIN_USERS_READ`
- `ADMIN_USERS_WRITE`
- `ADMIN_BILLING_READ`
- `ADMIN_BILLING_WRITE`
- `ADMIN_CRM_READ`
- `ADMIN_CRM_WRITE`
- `ADMIN_METADATA_READ`
- `ADMIN_METADATA_WRITE`
- `ADMIN_METADATA_PUBLISH`
- `ADMIN_INTEGRATIONS_READ`
- `ADMIN_INTEGRATIONS_WRITE`
- `ADMIN_INTEGRATIONS_PUBLISH`
- `ADMIN_CONFIG_READ`
- `ADMIN_CONFIG_WRITE`
- `ADMIN_CONFIG_PUBLISH`
- `ADMIN_AI_CONFIG`
- `ADMIN_AUDIT_READ`

`WRITE` ile `PUBLISH` mümkünse ayrılmalıdır.

Admin rolü sağlık verisine otomatik erişim sağlamaz.

---

# 21. Secrets yönetimi

Admin panelinde entegrasyon parametreleri yönetilse bile şu değerler düz metin tekrar gösterilmez:

- API secret
- client secret
- private key
- signing key
- provider token
- platform LLM secret

Admin:

- secret set/update edebilir,
- masked status görür,
- last rotated time görür,
- test connection çalıştırabilir.

Secret değerleri ayrı secret manager/vault'ta saklanır. Config DB sadece `secret_ref` tutar.

---

# 22. Integration verification

Her entegrasyon için admin panelinde:

- configuration status
- last connection test
- last successful sync
- last failed sync
- last provider error category
- verified capability set
- docs checked date
- adapter version
- environment

görülebilir.

`Test integration` gerçek kullanıcı sağlık verisini admin'e dökmemelidir. Sentetik/test hesabı veya kullanıcıdan bağımsız health-check tercih edilir.

---

# 23. Veri modeli ekleri

Mevcut modele minimum şu varlıkları ekle veya mevcut karşılıkları genişlet:

- `ConfigDefinition`
- `ConfigRevision`
- `ConfigValue`
- `ConfigRelease`
- `FeatureFlag`
- `FeatureFlagRevision`
- `MetadataRevision`
- `CatalogRelease`
- `IntegrationDefinition`
- `IntegrationRevision`
- `IntegrationCapability`
- `IntegrationCapabilityRevision`
- `IntegrationSourceMapping`
- `IntegrationVerification`
- `AdminChangeSet`
- `AdminPublishApproval`
- `AdminAuditEvent`

Mevcut `SportFamily`, `SportDiscipline`, `SportVariant`, `TrainingMethod`, `SessionPurpose`, `BodyRegion`, `MuscleGroup`, `MovementPattern`, `EquipmentDefinition`, `ContentItem` varlıklarının admin-managed lifecycle'ı desteklediğini doğrula.

Aynı kavram için ikinci tablo seti yaratma.

---

# 24. API ekleri

Örnek admin API'leri:

```text
GET    /v1/admin/metadata/sports
POST   /v1/admin/metadata/sports
PATCH  /v1/admin/metadata/sports/{id}

GET    /v1/admin/catalog/content
POST   /v1/admin/catalog/content
PATCH  /v1/admin/catalog/content/{id}

GET    /v1/admin/integrations
GET    /v1/admin/integrations/{id}
PATCH  /v1/admin/integrations/{id}
GET    /v1/admin/integrations/{id}/capabilities
PATCH  /v1/admin/integrations/{id}/capabilities
POST   /v1/admin/integrations/{id}/verify

GET    /v1/admin/config/definitions
GET    /v1/admin/config/releases
POST   /v1/admin/config/change-sets
PATCH  /v1/admin/config/change-sets/{id}
POST   /v1/admin/config/change-sets/{id}/validate
POST   /v1/admin/config/change-sets/{id}/publish
POST   /v1/admin/config/releases/{id}/rollback

GET    /v1/admin/feature-flags
POST   /v1/admin/feature-flags
PATCH  /v1/admin/feature-flags/{id}
```

Public/app config için ayrı, salt okunur ve filtrelenmiş endpoint:

```text
GET /v1/app/config
GET /v1/app/catalog/version
GET /v1/app/integrations
```

Admin-only alanlar public endpoint'e sızmamalıdır.

---

# 25. Cache ve invalidation

Published config/metadata değişikliğinde:

- backend cache invalidation
- CDN/cache varsa version-key
- worker cache invalidation
- iPhone ETag/version refresh

uygulanmalıdır.

Tek bir admin değişikliği yüzünden bütün kullanıcıların aynı anda full catalog indirmesi engellenmelidir.

Config küçük snapshot/delta; catalog versioned/paged olmalıdır.

---

# 26. Migration — hard-coded alanlardan admin-managed yapıya geçiş

Kodlama LLM'i önce mevcut repo'da şunları bulmalıdır:

- enums
- switch/case sport handling
- hard-coded integration names
- provider enabled booleans
- hard-coded exercise category arrays
- static muscle groups
- AI provider lists
- source app lists
- onboarding sport arrays
- static UI labels
- provider capability assumptions

Her bulgu için migration tablosu çıkar:

| Current | Target | Migration |
|---|---|---|
| hard-coded sport enum | stable code + DB metadata | backfill mapping |
| static category array | managed taxonomy | seed + version |
| provider boolean | IntegrationDefinition | migrate defaults |
| UI display text | localization metadata | stable key |
| hard-coded capability | verified capability registry | safe upper-bound |

**Core domain logic gereken yerde enum kullanmaya devam edebilir**, fakat kullanıcıya gösterilen katalog ve yönetilebilir sınıflandırma kod enum'una kilitlenmemelidir.

---

# 27. Backward compatibility

Her published config/catalog release:

- `min_supported_app_version`
- `schema_version`
- `backward_compatible`
- `requires_client_update`

taşımalıdır.

Eski app version için:

- uyumlu payload üret,
- veya özellik görünürlüğünü kapat,
- kritik durumda açık update requirement göster.

Bilinmeyen field crash sebebi olmamalıdır.

---

# 28. Güvenlik kuralları

Admin paneli:

- MFA zorunlu,
- RBAC,
- CSRF/session protection,
- audit,
- rate limit,
- sensitive action step-up,
- publish confirmation,
- bulk change preview,
- export limits

uygulamalıdır.

Her audit kaydı:

- actor
- time
- environment
- object
- before/after diff
- reason
- publish/change-set ID
- request trace

saklamalıdır.

API key veya sağlık payload'ı audit log'a yazılmaz.

---

# 29. Minimum kabul testleri

### TAX-ADM-01
Admin yeni sport discipline ekler → publish eder → desteklenen iPhone app sürümünde katalogda görünür → app release gerekmez.

### TAX-ADM-02
Admin sport'u inactive yapar → geçmiş planlardan silinmez → yeni plan seçiminden kaldırılır.

### TAX-ADM-03
Admin muscle group adını değiştirir → stable ID korunur → geçmiş exercise ilişkileri bozulmaz.

### TAX-ADM-04
Admin exercise'ı deprecated yapıp replacement tanımlar → yeni seçimlerde replacement önerilir → geçmiş plan snapshot'ı değişmez.

### TAX-ADM-05
Garmin/source mapping değiştirilir → ham source record değişmez → yeni mapping revision izlenebilir.

### INT-ADM-01
Admin Google/Huawei integration görünürlüğünü kapatır → yeni kullanıcı bağlantı ekranında görmez → mevcut bağlantı davranışı tanımlı politika ile devam eder.

### INT-ADM-02
Admin provider'ı maintenance moduna alır → kullanıcı doğru bilgilendirme görür → veri kaybı yaşanmaz.

### INT-ADM-03
Admin teknik olarak unsupported Samsung iOS capability'sini ACTIVE yapmaya çalışır → validation reddeder.

### INT-ADM-04
Admin HRV capability'sini product-disabled yapar → plan motoru bu metrik varmış gibi kullanmaz.

### INT-ADM-05
Integration config rollback → önceki çalışan sürüm geri gelir → user connections duplicate olmaz.

### CFG-ADM-01
Admin invalid `planning.max_active_goals=-1` girer → publish engellenir.

### CFG-ADM-02
Config endpoint erişilemiyor → iPhone son geçerli snapshot ile çalışır.

### CFG-ADM-03
Yeni schema eski app tarafından tanınmıyor → backward compatibility path çalışır veya controlled update state gösterilir.

### CFG-ADM-04
Draft config hiçbir production app'e görünmez.

### CFG-ADM-05
Publish sonrası backend ve iPhone aynı config version referansıyla DecisionRecord üretir.

### SEC-ADM-01
CRM/support admin'i integration publish etmeye çalışır → 403.

### SEC-ADM-02
Metadata editor secret okumaya çalışır → erişemez.

### SEC-ADM-03
Admin UI'dan arbitrary URL/internal IP provider endpoint girilerek SSRF denenir → engellenir.

### SEC-ADM-04
Admin config ile consent bypass etmeye çalışır → backend reddeder.

### REG-ADM-01
Extension uygulanınca mevcut v6 login, plan, adaptation, coach, billing/CRM ve catalog testleri regresyon olmadan geçer.

---

# 30. Development plan — yalnız delta

## EXT-D0 — As-is inventory

- mevcut hard-coded metadata/config/integration noktalarını tara
- tekrar eden enum ve static listeleri bul
- güvenlik nedeniyle kodda kalacak kuralları ayır
- migration matrix çıkar

**Teslimat:** `ADMIN_MANAGED_CONFIG_GAP_ANALYSIS.md`

## EXT-D1 — Configuration foundation

- config schema
- revisions
- releases
- change sets
- RBAC
- audit
- publish/rollback

## EXT-D2 — Taxonomy & metadata migration

- sport family/disciplines/variants
- muscles/body regions/patterns/equipment
- localization
- ordering/visibility
- mevcut IDs/mappings korunarak migration

## EXT-D3 — Integration Registry

- provider definitions
- capability matrix
- visible/connectable/enabled/maintenance states
- verification evidence
- source mappings

## EXT-D4 — Web Admin UI

- Metadata
- Content
- Integrations
- Configuration
- Feature Flags
- Release/Diff/Rollback

Mevcut v6 Users/Billing/CRM ekranlarıyla aynı admin uygulamasına ekle.

## EXT-D5 — iOS remote consumption

- versioned `/app/config`
- catalog version
- integration list
- ETag/cache
- safe fallback
- schema compatibility

## EXT-D6 — Regression & migration

- eski plan/history
- existing users
- current integrations
- old app versions
- authorization
- consent
- billing/CRM
- full v6 regression suite

---

# 31. Tamamlanma tanımı

Bu extension şu koşullarda tamamlanmış sayılır:

1. Spor/metadata listelerinin ana bölümü kod değişikliği olmadan admin'den yönetilebilir.
2. Metadata version/publish/rollback çalışır.
3. Source mapping ve canonical taxonomy admin'den yönetilebilir.
4. Entegrasyonlar merkezi registry'de görünür.
5. Görünürlük / yeni bağlantı / backend enabled / maintenance birbirinden ayrıdır.
6. Capability matrix gerçeği aşan admin değişikliğine izin vermez.
7. iPhone uygulaması published config ve catalog version'ı kullanır.
8. Network yokluğunda son geçerli config ile çalışır.
9. Geçmiş plan ve aktivite metadata değişikliğinden bozulmaz.
10. Bütün admin değişiklikleri auditlidir.
11. Admin rolü sağlık verisine veya secret'lara otomatik erişim sağlamaz.
12. Mevcut v6 işlevlerinde regresyon yoktur.
13. Extension uygulanırken proje baştan yazılmamıştır.

---

# 32. Kodlama LLM’ine kısa prompt

> Mevcut Sportapp v6 kodunu ve daha önce verdiğim v6 gereksinim dokümanını koru. Baştan geliştirme yapma. Bu yeni isteği DELTA olarak uygula.
>
> Uygulamadaki mümkün olan metadata'yı — sport family, sport type/discipline, category, sub-sport/variant, training method, session purpose, exercise/drill/pose, muscle group, body region, movement pattern, equipment, level, aliases, localization, source mappings ve görünürlük/sıralama bilgileri dahil — hard-code yapıdan versioned database-backed metadata yapısına geçir ve Web Admin'den yönetilebilir hale getir.
>
> Apple Health, Google Health, Huawei Health, Samsung Health ve gelecekteki tüm app/provider entegrasyonları için merkezi Integration Registry oluştur. Admin'de provider'ın görünürlüğü, yeni bağlantıya açık olup olmadığı, backend tarafında enabled/disabled olması, maintenance durumu, support status, veri türü/capability matrisi, source mappings, last verified bilgisi ve güvenli çalışma parametreleri yönetilebilsin.
>
> Tek bir enabled boolean kullanma. `is_visible_to_user`, `is_new_connection_allowed`, `is_enabled`, `existing_connections_behavior`, `maintenance_mode`, `support_status` gibi durumları ayır.
>
> Provider teknik olarak desteklemiyorsa admin toggle bunu destekleniyor hale getiremesin. HealthKit entitlement, iOS sandbox, auth/RBAC, consent enforcement, encryption, secret management, safety-critical hard limits ve provider'ın gerçek API capability sınırları admin config ile bypass edilemesin.
>
> Web Admin'e Metadata, Content Catalog, Taxonomy/Mapping, Integrations, Capability Matrix, Product Configuration, Feature Flags ve Config/Catalog Release-Diff-Rollback ekranlarını ekle. Mevcut Users/Billing/CRM ekranlarını bozma.
>
> Config/metadata değişiklikleri Draft → Validate → Publish → Active/Superseded/Rollback yaşam döngüsüyle çalışsın. Stable internal IDs/codes korunmalı; geçmiş plan ve aktiviteler display metadata değişince sessizce değişmemeli. Published plans ContentSnapshot ve catalog/config version taşımalı.
>
> iPhone uygulaması sadece published config almalı; ETag/version ile cache etmeli, offline durumda son geçerli config'i kullanmalı, yeni schema eski app'i crash ettirmemeli. App/backend karar kayıtlarında kullanılan catalog/config version tutulmalı.
>
> Önce mevcut kodda hard-coded enum/list/provider/capability/config noktalarını bul ve `ADMIN_MANAGED_CONFIG_GAP_ANALYSIS.md` üret. Sonra migration planı çıkar ve extension'ı mevcut mimariyi minimum bozarak uygula. Var olan ID'leri, kullanıcı geçmişini, planları, auth/permission yapısını ve v6 testlerini koru. Bütün yeni admin işlemleri RBAC + MFA + audit ile korunmalı ve mevcut v6 regresyon testleri tekrar çalıştırılmalı.
