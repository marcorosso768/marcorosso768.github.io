.abstract-toggle-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 11pt;
  padding: 6px 12px;
  margin-left: 30px;
  margin-top: 8px;
  background-color: #f0f0f0;
  border-radius: 999px;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s ease, transform 0.2s ease;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.abstract-toggle-pill:hover {
  background-color: #e6e6e6;
  transform: translateY(-1px);
}

.abstract-toggle-pill i {
  transition: transform 0.3s ease;
}

.abstract-toggle-pill:hover i {
  transform: scale(1.3);
}

.toggle-label {
  font-style: normal;
}
