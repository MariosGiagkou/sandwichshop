You are an assistant that will modify a Flutter app (project root: c:\Users\mario\Desktop\UNI\Programming\mani_week6\sandwich_shop). The app has an OrderScreen (select sandwiches) and a CartScreen (view cart + total). Implement cart-item modification UX & logic. For each feature below describe UI, state changes, validations, error handling, and test cases. Implementations should use the project's existing patterns (prefer minimal changes; use setState if the project is simple). Files likely to change: lib/views/cart_screen.dart, lib/views/order_screen.dart, lib/models/cart_item.dart, lib/models/menu_item.dart, lib/widgets/cart_item_tile.dart. Provide code snippets and unit tests where relevant.

Features & behaviours (clear descriptions + what must happen when the user acts):

1) Increment / Decrement quantity buttons
- Description: Each cart row shows + and − buttons to increase or decrease quantity.
- On action:
  - Press +: increase quantity by 1 up to maxQuantity (use existing maxQuantity from OrderScreen). If the quantity is at max, disable + and show a short tooltip/snackbar "Max quantity reached".
  - Press −: decrease quantity by 1. If result is 0, prompt a confirmation to remove the item (or optionally remove immediately depending on spec).
  - After change: update cart model, recalculate and update displayed item subtotal and cart total, persist change to local in-memory state (or local storage if present), and reflect change on any listening widgets.
  - Error handling: if persistence fails, revert UI and show error snackbar.

2) Direct numeric edit (tap quantity to edit)
- Description: Tapping the quantity opens a small dialog or bottom sheet with a numeric input (keyboard or stepper) so the user can type a quantity.
- On action:
  - Validate input is integer in [1, maxQuantity]. If invalid, show inline error and prevent confirm.
  - On confirm: update model, totals, and persist. Close dialog.
  - Accessibility: support larger tap targets and keyboard input on desktop.

3) Remove item
- Description: Each cart row has a trash icon to remove the item.
- On action:
  - Tap trash: show a confirmation dialog "Remove X from cart?" with Cancel/Remove.
  - On confirm: remove item from cart model, update totals and UI.
  - Show undo option: display a Snackbar "Removed X" with "UNDO" that restores the removed item when tapped (within snackbar duration).
  - Edge cases: if removing reduces cart to empty, show empty-cart state and disable checkout.

4) Edit item options (modify sandwich choices)
- Description: Allow editing of an existing cart item (change sandwich type, extras, or size).
- On action:
  - Tap an "Edit" icon (or the row) to navigate to the same item configuration screen used in OrderScreen, prefilled with the item's choices.
  - After user edits and confirms: replace the cart item (or update its attributes) and recalculate price. If the edited item becomes identical to another cart item, merge quantities (respecting maxQuantity) or prompt the user.
  - Persist and update totals. If merging would exceed maxQuantity, set to maxQuantity and notify user.

5) Save for later / Move to wishlist
- Description: Offer "Save for later" action per row (overflow menu).
- On action:
  - Move the item from cart to a "Saved" list stored in state.
  - Update totals and show "Saved for later" snackbar with option "MOVE BACK".
  - Provide a UI section on CartScreen to view saved items and move them back to cart (respecting maxQuantity).

6) Clear cart / bulk removal
- Description: Provide a "Clear cart" action in app bar or footer.
- On action:
  - Show confirmation dialog. On confirm: remove all items, update UI and totals.
  - Show undo snackbar to restore previous cart state if undone.

Acceptance criteria & tests to add
- Unit tests for:
  - increment/decrement logic enforces bounds and recalculates totals,
  - direct numeric edit validators,
  - remove item actually removes and undo restores,
  - edit item updates attributes and merges correctly,
  - save for later moves item and move-back works,
  - clearing cart empties state.
- Widget tests:
  - Tapping + updates UI quantity and subtotal,
  - Tapping trash shows confirmation and after confirm removes the row,
  - Snackbar undo restores state,
  - Dialog validations show errors for out-of-range input.

Implementation notes / constraints for the LLM
- Use existing project styling and patterns; prefer minimal intrusive changes.
- Keep state updates synchronous and simple (setState or an existing provider if present).
- Ensure totals are recalculated centrally (single source of truth).
- Add helpful and localized strings where necessary.
- Use Snackbars for undo and short messages; dialogs for confirmations and numeric input.
- Provide PR-style diff snippets and where to place new files if needed.

Return:
- A list of concrete UI and code changes (file + short snippet) to implement each feature.
- Unit and widget test examples for the most important flows (increment/decrement, remove+undo, edit merge).
- Any assumptions you make about missing project files or state management.

Keep the output concise and provide code snippets and test examples that can be applied directly to the project.