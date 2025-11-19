Cart item modification — Requirements Document
Overview
Feature: Allow users to modify items in their cart (change quantity, remove items, edit options, save for later, and clear cart).
Purpose: Improve checkout flexibility and reduce friction by enabling common cart-management tasks directly from the CartScreen while keeping totals accurate and state consistent.

Subtasks
Increment / Decrement quantity controls
Direct numeric edit (quantity dialog)
Remove item with confirmation + undo
Edit item options (re-open order configuration)
Save for later (wishlist) and move-back
Clear cart (bulk removal)
State, persistence, and error handling
Tests (unit & widget)
1. Feature description & purpose
Allow users to manage each cart row without leaving CartScreen:

Adjust item quantities within allowed bounds.
Remove items (with confirmation + undo).
Edit item configuration (size, extras, etc.) and merge duplicates.
Save items for later and restore.
Clear the entire cart.
Purpose: reduce abandonment, let users correct choices, and ensure the displayed subtotal/total are always correct.

2. User stories
Epic: As a customer, I want to modify items in my cart so I can correct quantity or options before checkout.

Increment / Decrement quantity
As a shopper, I want + and − buttons on each cart row so I can change quantities quickly.
Edge: If the quantity is at the store maximum I want the + button disabled and a message telling me the limit.
Direct numeric edit
As a desktop or mobile user, I want to tap the quantity to type a number so I can set large quantities faster.
Remove item
As a shopper, I want to remove an item using a trash action and be able to undo the removal in case I tapped it by mistake.
Edit item options
As a shopper, I want to reopen the item configuration I used when adding it so I can change its size, extras or base sandwich and update the cart price accordingly.
Save for later
As a shopper, I want to save an item for later (move to wishlist) so I can clear the cart but keep the item available to re-add.
Clear cart
As a shopper, I want to clear the whole cart after confirming, with an option to undo in case of accidental click.
Accessibility & error cases
As a user with accessibility needs, I want large tap targets and keyboard input for quantity editing.
As a user, I want clear validation messages and reliable state after failures (persistence errors revert to prior state).
3. Acceptance criteria (testable)
General

All cart manipulations update a single canonical cart state and recalculate item subtotals and the cart total immediately.
All actions that change state show appropriate feedback (dialog, snackbar, disabled state).
All user-visible strings are clear and localizable.
Subtask-specific criteria:

Increment / Decrement quantity
Each cart row displays increment and decrement buttons and current quantity.
Pressing + increases quantity by 1 up to maxQuantity; if quantity == maxQuantity:
is disabled.
Pressing + when disabled cannot increase quantity and shows a Snackbar "Max quantity reached".
Pressing − decreases quantity by 1. If the new quantity would be 0, a confirmation dialog appears:
Confirm: item removed and subtotal/total updated.
Cancel: quantity stays at 1.
After quantity change, item subtotal and cart total update synchronously.
If persistence fails, UI reverts to previous quantity and a Snackbar shows an error.
Direct numeric edit
Tapping the quantity opens a dialog/bottom sheet with a numeric input (or stepper).
Input must be integer inside [1, maxQuantity].
Invalid input blocks confirm and shows inline validation text.
On confirm with valid value, cart state updates and totals recalc; dialog closes.
Keyboard input available for desktop.
Remove item
Trash icon triggers a confirmation dialog "Remove <item name> from cart?" with Cancel / Remove.
On Remove: item removed, totals updated, and a Snackbar "Removed <item name>" with UNDO action appears.
If UNDO tapped before snackbar dismiss, item restored with previous quantity and totals restored.
If cart becomes empty, CartScreen switches to an empty state and checkout is disabled.
Edit item options
Each cart row has an Edit action (icon or whole-row tap).
Edit navigates to the same configuration UI used in OrderScreen, prefilled with the item choices.
On confirm:
If the edited item differs from original, the cart updates that item’s attributes and recalculates price.
If the edited item equals another existing cart item:
Merge quantities: newQuantity = min(sum, maxQuantity).
If sum > maxQuantity, merged quantity set to maxQuantity and a Snackbar informs "Merged items capped at max quantity".
The other duplicate row removed; totals updated.
Editing preserves timestamps/ids only as needed; undo is optional (editing undo not required but acceptable).
Save for later / Move to wishlist
Each row overflow includes "Save for later".
On action: item removed from cart and placed in Saved list; totals update.
Snackbar "Saved for later" with MOVE BACK action appears.
CartScreen has a Saved section visible when saved items exist; tapping MOVE BACK attempts to re-add to cart with quantity limited by maxQuantity and warns if capped.
Clear cart / bulk removal
AppBar or footer includes "Clear cart".
Tap shows confirmation dialog. On confirm:
Cart emptied; totals = 0; empty state displayed.
Snackbar with UNDO restores previous cart state if tapped while snackbar active.
Tests
Unit tests:
increment enforces maxQuantity and recalculates totals,
decrement removes item when confirmed and respects cannot-go-below-1 rule,
direct edit validator allows only integers in [1,maxQuantity],
remove+undo restores previous state,
edit merges duplicates and caps at maxQuantity,
save-for-later moves item and move-back works,
clear-cart empties and undo restores.
Widget tests:
Tap + updates UI quantity and subtotal,
Tap trash shows confirmation; confirm removes row,
Undo snackbar restores removed row,
Dialog rejects out-of-range numeric input.
4. Error handling & persistence
Where persistence (local storage / database) exists, perform optimistic UI update and persist in background:
On persistence success: do nothing further.
On persistence failure: revert UI to previous state and show error Snackbar "Could not update cart. Try again."
All dialogs and snackbars should be cancelable and not block UI threads.
When merging causes capping at maxQuantity, show non-blocking notification (Snackbar) explaining action.
5. UX details / UI states
Cart row elements: thumbnail, name, options summary, price per unit, quantity control (−, quantity, +) with quantity tappable, subtotal, Edit icon, Overflow (Save for later), Trash icon.
Disable checkout button when cart is empty.
Empty cart screen: friendly illustration, "Start ordering" CTA navigates to OrderScreen.
Saved-for-later section collapsible and integrated under cart items or as a separate tab/section on CartScreen.
Accessibility

Buttons and tappable targets meet recommended minimum sizes.
Quantity dialog supports keyboard entry and screen readers announce changes and errors.
6. Assumptions
Project uses simple setState-based state; no global provider required (if provider/Bloc exists adapt accordingly).
Models: CartItem includes id, menuItemId, options, quantity, unitPrice, subtotal getter.
OrderScreen exposes maxQuantity (currently passed in main.dart). Use a single maxQuantity constant accessible to CartScreen (e.g., move to config or pass via constructor).
There is an existing route/flow for configuring an item in OrderScreen that can be reused for editing.
Persistence is in-memory or local; API persistence not required for MVP but should be handled similarly.
Localization not required for MVP but use string keys or central constants when possible.
7. Deliverables (developer-facing)
UI changes:
Add quantity controls and Edit/Trash/Overflow actions to cart_item_tile.dart.
Add numeric-edit dialog widget (QuantityEditDialog).
Add Saved list UI on CartScreen.
Add Clear cart action in AppBar/footer.
State updates:
Centralize totals calculation in cart model/service.
Implement undo logic storing recent change snapshot.
Tests:
Unit tests for cart logic.
Widget tests for +/−, removal+undo, numeric dialog validation.
Small PR-style diffs for the above files and test files.
8. Minimal success criteria (MVP)
Users can increase/decrease quantity with +/−, with bounds enforced and totals updated.
Users can remove items with confirmation and undo via Snackbar.
Users can edit item options and the cart updates price and merges duplicates.
Users can Save for later and move items back.
Clear cart works with confirmation and undo.

<!-- Appended: implementation prompt and verification checklist for "Cart item modification" feature -->

Implementation prompt for "Cart item modification" (for the developer/assistant)
Purpose
Provide a clear, executable prompt that a developer or an assistant (like you) can use to implement the Cart item modification feature described above. The implementation must be broken into small, commit-sized subtasks and include the required acceptance criteria and tests.

Instruction to implementer
- Read this requirements document end-to-end before coding.
- Break the work into independent subtasks (each commit-sized). Each subtask should modify only the files necessary and include tests when applicable.
- Use setState and existing models unless a clear benefit of introducing a state-management library is required; notify if such a change is proposed.
- Keep UI changes accessible and follow existing app styles (app_styles.dart).
- Do not change unrelated files.

Primary deliverables
1. Increment / Decrement quantity controls on CartScreen (buttons wired to Cart model).
2. Numeric quantity edit dialog (validation [1..kMaxQuantity]).
3. Remove item with confirmation + Snackbar UNDO.
4. Edit item options (reopen OrderScreen configuration with prefilled values and merge duplicates).
5. Save-for-later list UI and move-back logic.
6. Clear cart (AppBar/footer) with confirm + undo.
7. Unit tests for cart logic and at least basic widget tests for +/− and remove+undo.

Suggested commit-sized subtasks (implement one per commit)
A. Enforce quantity bounds in model
   - Files: lib/models/cart.dart
   - Add: kMaxQuantity in a central place (or reuse existing), add setQuantity(sandwich, qty), incrementQuantity, decrementQuantity.
   - Tests: unit tests for bounds & total recalculation.

B. Add + / − buttons to cart item UI
   - Files: lib/views/cart_screen.dart
   - Use cart.incrementQuantity/decrementQuantity and setState; show Snackbar when max reached.
   - Tests: widget test tapping buttons updates UI subtotal/total.

C. Numeric edit dialog
   - Files: lib/views/cart_screen.dart (or add lib/views/widgets/quantity_edit_dialog.dart)
   - Validate integer input in [1, kMaxQuantity]; call setQuantity on confirm.
   - Tests: dialog validation unit/widget test.

D. Remove item with confirm + UNDO
   - Files: lib/views/cart_screen.dart, lib/models/cart.dart
   - Implement snapshot restore logic for undo (store last removed item state).
   - Tests: unit test for undo restores counts and totals; widget test for snackbar UNDO.

E. Edit item options flow
   - Files: lib/views/order_screen.dart, lib/views/cart_screen.dart, lib/models/cart.dart
   - Reuse OrderScreen configuration route; on confirm update cart (merge duplicates respecting kMaxQuantity).
   - Tests: unit test for merge & capping behaviour.

F. Save for later (Saved list)
   - Files: lib/views/cart_screen.dart, lib/models/cart.dart (or new SavedRepository)
   - Visible Saved section; MOVE BACK action re-adds items with cap.
   - Tests: unit tests for saved list and move-back behavior.

G. Clear cart with confirm + undo
   - Files: lib/views/cart_screen.dart, lib/models/cart.dart
   - Tests: unit test for clear + undo.

Files likely to change (non-exhaustive)
- lib/models/cart.dart
- lib/models/sandwich.dart (if serialization or id fields required)
- lib/views/cart_screen.dart
- lib/views/order_screen.dart (for edit flow)
- lib/views/widgets/quantity_edit_dialog.dart (suggested)
- lib/views/sign_in_screen.dart (if user link placement changes)
- test/... (unit & widget tests)

Acceptance criteria (short)
- +/− buttons change quantity and totals immediately; + disabled at max and shows Snackbar "Max quantity reached".
- Tapping quantity opens numeric dialog; validation enforces integer in [1..kMaxQuantity].
- Removing item shows confirm dialog; on confirm, Snackbar "Removed <name>" with UNDO restores item.
- Editing options reuses OrderScreen config and merges duplicates; merged quantity capped at kMaxQuantity with Snackbar notice.
- Saved-for-later moves item out of cart and allows MOVE BACK.
- Clear cart confirmation works and UNDO restores previous cart.
- Checkout button disabled when cart is empty.

Testing requirements
- Unit tests for model methods (setQuantity, increment, decrement, merge, total recalculation).
- Widget tests for CartScreen: plus/minus increments, remove confirmation, UNDO behavior, numeric input validation.

Verification checklist (to use before coding)
- [ ] The prompt and subtasks are present in the requirements.md file.
- [ ] kMaxQuantity location decided (either keep in cart.dart or move to config); update references.
- [ ] Routes used for edit flow exist and accept prefilled arguments (OrderScreen).
- [ ] app_styles.dart is used for new UI elements to keep visual consistency.
- [ ] Tests to cover each subtask are listed and prepared to be added.

Notes to implementer
- Favor minimal, reversible changes per commit.
- Use SnackBar durations long enough for user to press UNDO but not intrusive.
- When merging duplicates, gracefully notify user if capping occurs.
- If persistence/push to storage is later added, follow optimistic UI update and revert on failure as described in the requirements.

End of appended prompt.

<!-- Appended: Drawer navigation note -->

Drawer navigation (added)
- A Drawer has been added to CartScreen to provide quick access to top-level destinations.
- Items: Order (returns to home/root), About (navigates to /about), Profile (navigates to /sign_in).
Acceptance checks:
- Drawer opens from the Cart screen AppBar (hamburger) and shows listed items.
- Tapping Order closes the drawer and returns to the app root (Order UI).
- Tapping About opens the About screen via existing route '/about'.
- Tapping Profile opens the Sign-in/Profile screen via '/sign_in'.
- Drawer closes automatically on item tap.
- No new routes were introduced; existing routes are used.

End of appended Drawer note.