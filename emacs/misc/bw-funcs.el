(defun bw/switch-to-previous-buffer ()
  "Switch to previously open buffer.
   Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))


; function to find my dotfile
(defun bw/find-dotfile ()
  "Edit init.el."
  (interactive)
  (find-file  user-init-file))

(provide 'bw-funcs)
