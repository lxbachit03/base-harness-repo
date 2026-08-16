# Flow Activity Diagram: <Flow Name>

**Target Flow**: `<flow-name>`
**Primary Entry Point**: `<entry-point-file-and-function>`
**Terminal Exit Point**: `<exit-point-file-and-function>`

---

## 1. Visual Activity & Sequence Diagram (Mermaid)

> [!IMPORTANT]
> **Line Range Annotation Rule**:
> Every step, node, state transition, and conditional branch in the Mermaid diagram **MUST explicitly include the relative file path and code line ranges** in the node label.

```mermaid
flowchart TD
    %% Entry Point
    Start(["Client / Ingestion Trigger"]) --> Step1["Parse & Validate Request<br/>(src/api/auth.ts:L15-L35)"]
    
    %% Processing & Validation
    Step1 --> Decision1{"Valid Payload?<br/>(src/api/auth.ts:L36-L45)"}
    
    Decision1 -- "No" --> ErrorHandler["Emit 400 Bad Request<br/>(src/errors/handler.ts:L12-L28)"]
    Decision1 -- "Yes" --> Step2["Execute Core Transformation<br/>(src/services/auth-service.ts:L50-L85)"]
    
    %% Persistence / Integration
    Step2 --> Step3["Database Write / State Mutation<br/>(src/models/user.ts:L100-L125)"]
    
    %% External Side Effects
    Step3 --> Step4["Publish Event to Queue<br/>(src/events/publisher.ts:L18-L40)"]
    
    %% Success Exit
    Step4 --> EndSuccess(["Return Success Response<br/>(src/api/auth.ts:L86-L95)"])
```

---

## 2. Step-by-Step Code References

| Step | Component / Action | Exact Source File & Line Range | Observed Behavior |
| :--- | :--- | :--- | :--- |
| **1** | `<Action 1>` | `[path/to/file.ts:L10-L30](file:///path/to/file.ts#L10-L30)` | `<Description of behavior>` |
| **2** | `<Action 2>` | `[path/to/file.ts:L31-L55](file:///path/to/file.ts#L31-L55)` | `<Description of behavior>` |
| **3** | `<Action 3>` | `[path/to/file.ts:L56-L90](file:///path/to/file.ts#L56-L90)` | `<Description of behavior>` |

---

## 3. Branches & Error Paths

- **Condition 1 (`<Branch Name>`)**:
  - *Trigger Condition*: `<When condition occurs>`
  - *Code Reference*: `[path/to/file.ts:L40-L50](file:///path/to/file.ts#L40-L50)`
  - *Fallback / Error Mitigation*: `<How error is handled>`

- **Condition 2 (`<Branch Name>`)**:
  - *Trigger Condition*: `<When condition occurs>`
  - *Code Reference*: `[path/to/file.ts:L60-L75](file:///path/to/file.ts#L60-L75)`
  - *Fallback / Error Mitigation*: `<How error is handled>`
