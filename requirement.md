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